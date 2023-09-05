//
//  CreateReviewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/31.
//

import UIKit
import SnapKit
import PhotosUI

protocol CreateReviewControllerDelegate: AnyObject {
    func endFlow()
}
class CreateReviewController: BaseViewController {
    var didSendEventClosure: ((CreateReviewController.Event) -> Void)?
    
    enum Event {
        case dismiss
    }
    
    let createReviewView = CreateReviewView()
    weak var delegate: CreateReviewControllerDelegate?
    var recipeID: Int

    init(recipeID: Int) {
        self.recipeID = recipeID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .orange
        view.addSubview(createReviewView)
        createReviewView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        createReviewView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        createReviewView.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension CreateReviewController: CreateReviewViewDelegate {
    func didTapRegisterButton(_ rating: Int, _ contents: String, _ img: [UIImage]) {
        print(rating)
        print(contents)
        print(img)
        var urlList: [String] = []
        Task {
            for photo in img {
                guard let stage = await addImage(img: photo) else { return }
                urlList.append(stage.data)
            }
            let parameter = ["review_content": contents,
                             "review_imgs": urlList,
                             "review_rating": rating]
            let result: ReviewResult = try await NetworkManager.shared.get(.createReview("\(self.recipeID)"), parameters: parameter)
            
            if result.code == "SUCCESS" {
                delegate?.endFlow()
            }
            
//            AddReview
        }
//        newStage.append(data)
        
//        delegate?.endFlow()
        
//        self.dismiss(animated: true)
//        didSendEventClosure?(.dismiss)
    }
    
    func didTapAddImageButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func addImage(img: UIImage) async -> UploadResult? {
        print(#function)
        do {
            let result: UploadResult = try await NetworkManager.shared.editActivity(endpoint: .imageUpload, imageData: img)
            return result
        } catch {
            print("An error occurred: \(error)")
            return nil
            // 에러를 처리합니다.
        }
        
    }
}

extension CreateReviewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    // 선택한 이미지 처리
//                    print(image)
                    self.createReviewView.getImageRelay.accept(image)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
