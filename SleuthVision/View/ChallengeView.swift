//
//  ChallangeView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import SwiftUI
import AVKit
import Vision

struct ChallengeView: View {
    let challenge: Int
    @StateObject var challengeOb = ChallengeObservable()
    @State var showImagePredictionView = false
    @State var _class = ""
    
    var body: some View {
        ZStack(alignment: .topTrailing) { // Align content to the top-left corner
            HostedViewController(chal: challenge, challengeOb: challengeOb)
                .ignoresSafeArea()
            
//            NavigationLink(value: challenge) {
//                EmptyView()
//            }
            
            NavigationLink(
                destination: ImagePredictionView(_class: _class),
                isActive: $showImagePredictionView,
                label: {
                    EmptyView() // Use empty view as label
                })
            
            VStack(alignment: .trailing) {
                ForEach(challengeOb.detectedItemsLabel.filter { $0.value }.keys.sorted(), id: \.self) { key in
                    RectangleHints(itemLabel: key, _classBind: $_class, showImagePredict: $showImagePredictionView)
                }
            }
            .padding() // Add padding to adjust spacing
            
        }
    }
}

//struct RectangleHints: View {
//    let itemLabel: String?
//    @State private var isButtonClicked = false
//
//    var body: some View {
//        HStack {
//            if let itemLbl = itemLabel, let hints = game0.itemDictionary[itemLbl]?.hints.joined(separator: " ") {
//                Text("\(hints)") // Display the hints
//                    .foregroundColor(.white) // Text color
//                    .font(.headline)
//                    .padding(.vertical, 5)
//                    .padding(.horizontal, 10)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10) // Rounded rectangle
//                            .foregroundColor(Color.black.opacity(0.5)) // Adjust opacity as needed
//                        // Adjust padding as needed
//                    )
//            }
//
//            Button(action: {
//                isButtonClicked.toggle()
//                if let itemLbl = itemLabel, let _class = game0.itemDictionary[itemLbl]?._class {
//                    print(_class)
//                }
//            }) {
//                Image(systemName: "sparkle.magnifyingglass") // Magnifying glass icon
//                    .foregroundColor(.white) // Icon color
//                    .font(.system(size: 20)) // Icon size
//            }
//            .padding(8) // Adjust padding as needed
//            .background(Color.black.opacity(0.5)) // Button background
//            .clipShape(Circle()) // Clip button into a circle shape
//            .opacity(isButtonClicked ? 0.5 : 1.0) // Dim button when clicked
//            .disabled(isButtonClicked) // Disable button when clicked
//        }
//
//    }
//}

struct RectangleHints: View {
    let itemLabel: String?
    @State private var isButtonClicked = false
    @State private var isTextVisible = false // State variable to control text visibility
    
    @Binding var _classBind : String
    @Binding var showImagePredict : Bool
    
    var body: some View {
        HStack {
            if isTextVisible {
                if let itemLbl = itemLabel, let hints = game0.itemDictionary[itemLbl]?.hints.joined(separator: " ") {
                    Text("\(hints)") // Display the hints
                        .foregroundColor(.white) // Text color
                        .font(.title)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10) // Rounded rectangle
                                .foregroundColor(Color.black.opacity(0.5)) // Adjust opacity as needed
                            // Adjust padding as needed
                        )
                }
            }
            
            Button(action: {
                isButtonClicked.toggle()
                showImagePredict.toggle()
                if let itemLbl = itemLabel, let _class = game0.itemDictionary[itemLbl]?._class {
                    _classBind = _class
                }
                
                
            }) {
                Image(systemName: "sparkle.magnifyingglass") // Magnifying glass icon
                    .foregroundColor(.white) // Icon color
                    .font(.system(size: 24)) // Icon size
            }
            .padding(12) // Adjust padding as needed
            .background(Color.black.opacity(0.5)) // Button background
            .clipShape(Circle()) // Clip button into a circle shape
            .opacity(isButtonClicked ? 0.5 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) { // Apply animation on appear
                isTextVisible = true // Set text visibility to true
            }
        }
    }
}

struct ImagePredictionView : View {
    let _class : String
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var isCorrectPrediction = false
    @State private var predictions: [ImagePredictor.Prediction]? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Button(action: {
                        print("Button tapped")
                    }) {
                        Image(systemName: isCorrectPrediction ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 72))
                            .foregroundColor(isCorrectPrediction ? .green : .red)
                    }
                    .padding()
                    .shadow(color: .black.opacity(0.6), radius: 10) // Add shadow
                    
                    if !isCorrectPrediction {
                        Button(action: {
                            showSheet = true
                        }) {
                            Image(systemName: "sparkle.magnifyingglass")
                                .font(.system(size: 39))
                                .foregroundColor(.white) // Icon color
                        }
                        .padding()
                        .background(Color.black.opacity(0.3)) // Button background
                        .clipShape(Circle()) // Clip button into a circle shape
                        .shadow(color: .black.opacity(0.6), radius: 10) // Add shadow
                    }
                    
                }
                
                
            }
        }
        .sheet(isPresented: $showSheet) {
            ZStack {
                ImagePicker(sourceType: .camera) { selectedImage in
                    self.image = selectedImage
                    // Call the image predictor to make prediction
                    do {
                        try ImagePredictor().makePredictions(for: selectedImage) { predictions in
                            // Handle the predictions
                            self.predictions = predictions
                            
                            // Example: Check if prediction is correct
                            if let firstPrediction = predictions?.first {
                                print(firstPrediction.classification)
                                if firstPrediction.classification == _class {
                                    self.isCorrectPrediction = true
                                } else {
                                    self.isCorrectPrediction = false
                                }
                            }
                        }
                    } catch {
                        print("Error predicting image: \(error.localizedDescription)")
                    }
                    
                }
            }
            .onAppear() {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                ScreenOrientationDelegate.orientationLock = .portrait
            }
            .onDisappear() {
                ScreenOrientationDelegate.orientationLock = .all
            }
        }
        .onAppear(perform: {
            showSheet = (image.size.width == 0.0)
        })
    }
}


#Preview {
    //    RectangleHints(itemLabel: "apple")
    ImagePredictionView(_class: "lemon")
}


struct PreviewLayerView: UIViewRepresentable {
    var session: AVCaptureSession
    
    let screenRect = UIScreen.main.bounds
    
    func makeUIView(context: Context) -> UIView {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let view = UIView(frame: UIScreen.main.bounds)
        previewLayer.frame = view.bounds
        
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
}

struct DetectedObjectView: View {
    let result: VNRecognizedObjectObservation
    let imageSize: CGSize
    
    var body: some View {
        // Calculate bounding box position and size
        let rect = result.boundingBox.scaled(to: imageSize)
        
        // Draw bounding box
        Rectangle()
            .stroke(Color.red, lineWidth: 2)
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
    }
}

extension CGRect {
    func scaled(to size: CGSize) -> CGRect {
        CGRect(
            x: self.origin.x * size.width,
            y: self.origin.y * size.height,
            width: self.size.width * size.width,
            height: self.size.height * size.height
        )
    }
}

//
//            if challengeVM.permissionGranted {
//                PreviewLayerView(session: challengeVM.captureSession)
//                    .overlay(
//                        GeometryReader { geometry in
//                            // Draw bounding boxes or other visual indicators based on detection results
//                            ForEach(challengeVM.detectionResults, id: \.self) { result in
//                                DetectedObjectView(result: result, imageSize: geometry.size)
//                            }
//                        }
//                    )
//                    .onAppear(perform: {
//                        challengeVM.challengeID = challenge
//                    })
//                    .ignoresSafeArea()
//            } else {
//                Text("Camera access denied")
//            }
//
