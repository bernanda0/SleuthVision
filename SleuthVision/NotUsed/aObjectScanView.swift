//
//  ObjectScanView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import SwiftUI
import AVKit

struct ObjectScanView : View {
    
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var objectCaptured: AVCaptureMetadataOutput = .init()
    @State private var camPermission: Bool = false;
    
    var body: some View {
        VStack {
            
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    CameraPreview(frameSize: size, session: $session)
                        .ignoresSafeArea()

                }
                .frame(width: size.width, height: size.height)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
               
            }
            
        }.onAppear {
            checkCameraPermission()
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            ScreenOrientationDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            ScreenOrientationDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }.overlay(
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 325, height: 325)
                    .clipShape(Circle())
            }
        )
        
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: camPermission = true
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    camPermission = true
                }
            case .denied, .restricted :
                camPermission = false
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input), session.canAddOutput(objectCaptured) else {
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(objectCaptured)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct CameraPreview: UIViewRepresentable {
    var frameSize: CGSize
    
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspect
        cameraLayer.masksToBounds = true
        
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    ObjectScanView()
}

