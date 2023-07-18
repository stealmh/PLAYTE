//
//  CreateRecipeViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class CreateRecipeViewController: BaseViewController {
    
    private let createRecipeView = CreateRecipeView()
    private var disposeBag = DisposeBag()
    var didSendEventClosure: ((CreateRecipeViewController.Event) -> Void)?
    let imagePicker = UIImagePickerController()
    
    enum Event {
        case registerButtonTapped
        ///Todo: createShortFormButtonTapped 로직 연결하기
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        bind()
        createRecipeView.delegate = self
        imagePicker.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
        createRecipeView.delegate = nil
        imagePicker.delegate = nil
    }
}
//MARK: - Method(Normal)
extension CreateRecipeViewController {
    private func addView() {
        view.addSubViews(createRecipeView)
    }
    
    private func configureLayout() {
        createRecipeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - Method(Rx bind)
extension CreateRecipeViewController {
    func bind() {
        
    }
}

extension CreateRecipeViewController: CreateRecipeViewDelegate {
    func addPhotoButtonTapped() {
        print("받앗습니다")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self //3
        // imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func registerButtonTapped() {
        print(#function)
        didSendEventClosure?(.registerButtonTapped)
    }
}

//MARK: - Method(Image Picker)
extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageView.contentMode = .scaleAspectFit
            print(pickedImage)
            createRecipeView.imageRelay.accept(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct CreateRecipeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CreateRecipeViewController())
            .toPreview()
    }
}
