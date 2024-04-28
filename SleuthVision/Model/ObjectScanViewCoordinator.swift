//
//  ObjectScanViewCoordinator.swift
//  SleuthVision
//
//  Created by mac.bernanda on 28/04/24.
//

import Foundation
import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {
    var parent: ObjectScanViewController?
    
    init(parent: ObjectScanViewController) {
        self.parent = parent
    }
    
    func imagePicker(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
        picker.dismiss(animated: true)
        
        // Handle selected image
        if let image = info[.originalImage] as? UIImage {
            parent?.userSelectedPhoto(image)
        }
    }
}
