//
//  VideoPickerManager.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import Photos
import AVFoundation

class VideoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedVideoURL: URL?
    var videoPickedCompletion: ((URL?) -> Void)?
    
    func presentVideoPicker(in viewController: UIViewController, completion: @escaping (URL?) -> Void) {
        self.videoPickedCompletion = completion
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            showVideoPicker(in: viewController)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    self?.showVideoPicker(in: viewController)
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(in: viewController)
        @unknown default:
            break
        }
    }
    
    private func showVideoPicker(in viewController: UIViewController) {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = ["public.movie"] // Only allows video selection
        videoPicker.delegate = self
        viewController.present(videoPicker, animated: true, completion: nil)
    }
    
    private func showAppSettings() {
        guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }
    
    private func showPermissionDeniedAlert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "접근권한을 설정해주세요", message: "앨범에 접근해 동영상을 업로드합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
            self.showAppSettings()
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            let asset = AVURLAsset(url: videoURL, options: nil)
            let durationInSeconds = Double(asset.duration.value) / Double(asset.duration.timescale)
            
            if durationInSeconds <= 60 {
                selectedVideoURL = videoURL
                videoPickedCompletion?(videoURL)
                
                picker.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "알림", message: "60초 이하의 동영상만 업로드 가능합니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "알겠습니다", style: .default, handler: { _ in
                    picker.dismiss(animated: true, completion: nil)
                }))
                picker.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        videoPickedCompletion?(nil)
        picker.dismiss(animated: true, completion: nil)
    }
}
