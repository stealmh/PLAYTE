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
    let imagePickerManager = ImagePickerManager()
    private let viewModel = CreateRecipeViewModel()
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
        title = "나의 레시피 작성"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
        createRecipeView.delegate = nil
        imagePicker.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        createRecipeView.viewModel = viewModel
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
        
        imagePickerManager.presentImagePicker(in: self) { [weak self] img in
            guard let self = self, let img = img else { return }
            createRecipeView.imageRelay.accept(img)
            createRecipeView.imageBehaviorRelay.accept(img)
        }
    }
    
    func registerButtonTapped() {
        print(#function)
        didSendEventClosure?(.registerButtonTapped)
    }
    
    func addIngredientCellTapped(_ item: IngredientInfo) {
        let vc = AddIngredientViewController(item: item)
        vc.didSendEventClosure = { [weak self] cases in
            switch cases {
            case .okButtonTapped:
                self?.createRecipeView.addIngredientMockData.append(vc.forTag)
                self?.createRecipeView.dataSource.apply((self?.createRecipeView.createSnapshot())!, animatingDifferences: true)
            default:
                return
            }
        }
        vc.item = item
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: false)
    }
    
    func addThumbnailButtonTapped() {
        imagePickerManager.presentImagePicker(in: self) { [weak self] img in
            guard let self = self, let img = img else { return }
            self.createRecipeView.thumbnailImage.accept(img)
        }
    }
    
    func thumbnailModifyButtonTapped() {
        print(#function)
        imagePickerManager.presentImagePicker(in: self) { [weak self] img in
            guard let self = self, let img = img else { return }
            self.createRecipeView.thumbnailImage.accept(img)
        }
    }
}

////MARK: - Method(Image Picker)
//extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            //            imageView.contentMode = .scaleAspectFit
//            print(pickedImage)
//            createRecipeView.imageRelay.accept(pickedImage)
//            createRecipeView.imageBehaviorRelay.accept(pickedImage)
//        }
//        dismiss(animated: true, completion: nil)
//    }
//}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct CreateRecipeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CreateRecipeViewController())
            .toPreview()
    }
}
