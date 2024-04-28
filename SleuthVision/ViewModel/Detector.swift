//
//  Detector.swift
//  SleuthVision
//
//  Created by mac.bernanda on 28/04/24.
//

import Vision
import AVFoundation
import UIKit

class Detector {
    private var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    var challengeID: Int?
    var screenRect = UIScreen.main.bounds
    
    init() {
        setupDetector()
    }
    
    private func setupDetector() {
        do {
            let model = try yolov9c().model
            let visionModel = try VNCoreMLModel(for: model)
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    private func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }
    
    private func extractDetections(_ results: [Any]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            
            if let objectLabel = objectObservation.labels.first?.identifier as? String {
                if let chalId = challengeID {
                    if (objectObservation.confidence < 0.5 || !game0.getItemList(locationId: chalId).contains([objectLabel])){
                        return
                    }
                }
                
                
                if let hints = game0.itemDictionary[objectLabel]?.hints {
                    let boxLayer = self.drawBoundingBox(bounds: transformedBounds, label: objectLabel, hints: hints.joined(separator: " "))
                    detectionLayer.addSublayer(boxLayer)
                }
                
            }
            
        }
    }
    
    private func drawBoundingBox(bounds: CGRect, label: String, hints: String) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        
        return boxLayer
    }
}
