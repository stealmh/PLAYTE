//
//  ImagePickerManager.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedImage: UIImage?
    var imagePickedCompletion: ((UIImage?) -> Void)?
    
    func presentImagePicker(in viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.imagePickedCompletion = completion
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            imagePickedCompletion?(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
