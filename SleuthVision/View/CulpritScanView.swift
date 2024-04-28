//
//  CulpritScanView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import SwiftUI

enum PredictionState {
    case notCaptured
    case processed
    case correct
    case wrong
}

struct CulpritScanView : View {
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var predictionState: PredictionState = .notCaptured
    @State private var predictions: [ImagePredictor.Prediction]? = nil
    @State private var isAnimating = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Group {
                        if predictionState == .processed {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: UIScreen.main.bounds.width, height: 3) // Adjust width and height as needed
                                .offset(y: isAnimating ? UIScreen.main.bounds.height : 0)
                                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                                .onAppear {
                                    isAnimating = true
                                }
                        }
                    }
                )
            //                if predictionState == .processed {
            //                    Rectangle()
            //                        .fill(Color.blue)
            //                        .frame(width: UIScreen.main.bounds.width, height: 3) // Adjust width and height as needed
            //                        .offset(y: isAnimating ? UIScreen.main.bounds.height : 0)
            //                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            //                        .onAppear {
            //                            isAnimating = true
            //                        }
            //
            //                }
            
            HStack(alignment: .center) {
                if predictionState != .notCaptured && predictionState != .processed {
                    Button(action: {
                        print("Button tapped")
                    }) {
                        Image(systemName: imageNameForState(predictionState))
                            .font(.system(size: 72))
                            .foregroundColor(colorForState(predictionState))
                    }
                    .padding()
                    .shadow(color: .black.opacity(0.6), radius: 10)
                }
                
                if predictionState != .processed && predictionState != .correct {
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
        .sheet(isPresented: $showSheet) {
            ZStack {
                ImagePicker(sourceType: .camera) { selectedImage in
                    self.image = selectedImage
                    
                    ImageRecognizer(apiToken: "").recognizeImage(image: selectedImage) { result in
                    switch result {
                        case .success(let prediction):
                            predictionState = .correct
                            // Update prediction state based on the prediction resut
                            // For example:
                            print("Prediction: \(prediction)")
                            // Handle successful prediction
                        case .failure(let error):
                            predictionState = .wrong
                            //                            print("Error: \(error.localizedDescription)")
                            // Handle error
                        }
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
        .onChange(of: image) {
            predictionState = .processed
        }
    }
    
    func imageNameForState(_ state: PredictionState) -> String {
        switch state {
        case .notCaptured:
            return "xmark.circle.fill"
        case .processed:
            return "checkmark.circle.fill"
        case .correct:
            return "checkmark.circle.fill"
        case .wrong:
            return "xmark.circle.fill"
        }
    }
    
    func colorForState(_ state: PredictionState) -> Color {
        switch state {
        case .notCaptured:
            return .red
        case .processed:
            return .green
        case .correct:
            return .green
        case .wrong:
            return .red
        }
    }
}
