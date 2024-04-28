//
//  ChallengeVM.swift
//  SleuthVision
//
//  Created by mac.bernanda on 28/04/24.
//
import AVFoundation
import Vision
import UIKit

class ChallengeVM: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var permissionGranted = false
    @Published var detectedItemsLabel: [String] = [] 
    @Published var detectionResults: [VNRecognizedObjectObservation] = []
    
    var captureSession = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "sessionQueue")
    var videoOutput = AVCaptureVideoDataOutput()
    
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    var classes:[String] = []
    
    var screenRect = UIScreen.main.bounds
    var challengeID: Int?
    
    override init() {
        super.init()
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            self.setupDetector()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
    }
}

