//
//  ImagePickerManager.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedImage: UIImage?
    var imagePickedCompletion: ((UIImage?) -> Void)?
    
    func presentImagePicker(in viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.imagePickedCompletion = completion
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            showImagePicker(in: viewController)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    self?.showImagePicker(in: viewController)
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(in: viewController)
        @unknown default:
            break
        }
    }
    
    private func showImagePicker(in viewController: UIViewController) {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showPermissionDeniedAlert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "접근권한을 설정해주세요", message: "리뷰와 레시피 사진 등록을 위해 앨범에 접근합니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
            self.showAppSettings()
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func showAppSettings() {
        guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            imagePickedCompletion?(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
