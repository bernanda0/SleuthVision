//
//  ObjectScanExtension.swift
//  SleuthVision
//
//  Created by mac.bernanda on 28/04/24.
//

import PhotosUI
import UIKit

extension ObjectScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Creates a controller that gives the user a view they can use to take a photo with the device's camera.
    var cameraPicker: UIImagePickerController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        return cameraPicker
    }

    /// The delegate method UIKit calls when the user takes a photo with the camera.
    /// - Parameters:
    ///   - picker: A picker controller the `cameraPicker` property created.
    ///   - info: A dictionary that contains the photo.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: false)

        // Always return the original image.
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] else {
            fatalError("Picker didn't have an original image.")
        }

        guard let photo = originalImage as? UIImage else {
            fatalError("The (Camera) Image Picker's image isn't a/n \(UIImage.self) instance.")
        }

        userSelectedPhoto(photo)
    }
}

extension ObjectScanViewController: PHPickerViewControllerDelegate {
    /// Creates a controller that gives the user a view they can use to select a photo from the device's library.
    var photoPicker: PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self

        return photoPicker
    }

    /// The delegate method UIKit calls when the user selects a photo from the library.
    /// - Parameters:
    ///   - picker: A picker controller the `photoPicker` property created.
    ///   - results: An array of results. The method presumes the first result contains a photo.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)

        guard let result = results.first else {
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }

            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }

            self.userSelectedPhoto(photo)
        }
    }
}

