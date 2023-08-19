//
//  VideoPickerManager.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit

class VideoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedVideoURL: URL?
    var videoPickedCompletion: ((URL?) -> Void)?
    
    func presentVideoPicker(in viewController: UIViewController, completion: @escaping (URL?) -> Void) {
        self.videoPickedCompletion = completion
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = ["public.movie"] // Only allows video selection
        videoPicker.delegate = self
        viewController.present(videoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            selectedVideoURL = videoURL
            videoPickedCompletion?(videoURL)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        videoPickedCompletion?(nil)
        picker.dismiss(animated: true, completion: nil)
    }
}
