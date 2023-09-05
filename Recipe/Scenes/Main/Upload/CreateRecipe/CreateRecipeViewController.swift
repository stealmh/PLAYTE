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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .gray)
        title = "나의 레시피 작성"
        createRecipeView.viewModel = viewModel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
        createRecipeView.delegate = nil
        imagePicker.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        createRecipeView.viewModel = viewModel
//    }
    
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
            self.viewModel.imageRelay.accept(img)
            self.viewModel.imageBehaviorRelay.accept(img)
        }
    }
    
    func registerButtonTapped(_ item: UploadRecipe) async {
        print(#function)
        let beforeConvertData = item
        var newStage: [RecipeUploadForStep] = []
        guard let thumbnail = beforeConvertData.recipe_thumbnail_img.base64ToImage() else { return }
            /// 썸네일얻음
        DispatchQueue.main.async {
            LoadingIndicator.showLoading()
        }
        guard let thumbnailURL = await viewModel.addImage(img: thumbnail) else { return }
        
        for value in beforeConvertData.recipe_stages {
            if let stage = value.image_url.base64ToImage() {
                guard let stage = await viewModel.addImage(img: stage) else { return }
                let data = RecipeUploadForStep(image_url: stage.data, stage_description: value.stage_description)
                newStage.append(data)
            }
        }
        
        print(beforeConvertData.ingredients)

        let newData = UploadRecipe(cook_time: beforeConvertData.cook_time,
                                   ingredients: beforeConvertData.ingredients,
                                   recipe_description: beforeConvertData.recipe_description,
                                   recipe_name: beforeConvertData.recipe_name,
                                   recipe_stages: newStage,
                                   recipe_thumbnail_img: thumbnailURL.data,
                                   serving_size: beforeConvertData.serving_size)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(newData)
            let parameters = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]

            let result: RecipeUploadResult = try await NetworkManager.shared.get(.createRecipe, parameters: parameters)
            if result.code == "SUCCESS" {
                DispatchQueue.main.async {
                    LoadingIndicator.hideLoading()
                }
                didSendEventClosure?(.registerButtonTapped)
            }
            // Handle result
        } catch {
            print("Error:", error)
        }
    }
    
    func addIngredientCellTapped(_ item: IngredientInfo) {
        print(#function)
        let vc = AddIngredientViewController(item: item)
        vc.didSendEventClosure = { [weak self] cases in
            switch cases {
            case .okButtonTapped:
//                self?.createRecipeView.addIngredientMockData.append(vc.forTag)
                self?.viewModel.appendString(vc.forTag)
                self?.viewModel.addIngredient(vc.ingredient)
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
            self.viewModel.thumbnailImage.accept(img)
        }
    }
    
    func thumbnailModifyButtonTapped() {
        print(#function)
        imagePickerManager.presentImagePicker(in: self) { [weak self] img in
            guard let self = self, let img = img else { return }
            self.viewModel.thumbnailImage.accept(img)
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
