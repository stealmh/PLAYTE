//
//  CreateShortFormViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/22.
//

import Foundation
import RxSwift
import RxCocoa

/// 숏폼으로 수정하기
class CreateShortFormViewModel {
    
    var videoThumbnailImage = BehaviorRelay<UIImage?>(value: nil)
    var videoURLRelay = PublishRelay<URL>()
    var recipeTitleRelay = PublishRelay<String>()
    var recipeDescriptionRelay = PublishRelay<String>()
    var createRecipeIngredient = BehaviorRelay<[String]>(value: [])
    var ingredientList = BehaviorRelay<[Int]>(value: [])
    var ingredient = PublishRelay<Ingredient>()
    
    var currentVideoURL: URL? = nil
    var currentTitle: String? = nil
    var currentDescription: String? = nil
    var currentIngredientList: [Int] = []
    
    /// 모델 나오면 모델로 수정
    let allValuesReceived = PublishRelay<(image: UIImage?,
                                          videoURL: URL?,
                                          title: String?,
                                          description: String?,
                                          id: [Int],
                                          isValid: Bool)>()
    private var disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(
            videoThumbnailImage.asObservable(),
            videoURLRelay.asObservable(),
            recipeTitleRelay.asObservable(),
            recipeDescriptionRelay.asObservable(),
            ingredientList.asObservable()
        )
        .map { (image, videoURL, title, description, ingredients) -> (UIImage?, URL?, String?, String?, [Int], Bool) in
            let isValid = image != nil && !videoURL.isFileURL && !title.isEmpty && !description.isEmpty && !ingredients.isEmpty
            return (image, videoURL, title, description, ingredients, isValid)
        }
        .bind(to: allValuesReceived)
        .disposed(by: disposeBag)
        
        
        videoURLRelay.subscribe(onNext: { [weak self] data in
            self?.currentVideoURL = data
        }).disposed(by: disposeBag)
        
        recipeTitleRelay.subscribe(onNext: { [weak self] title in
            self?.currentTitle = title
        }).disposed(by: disposeBag)

        recipeDescriptionRelay.subscribe(onNext: { [weak self] description in
            self?.currentDescription = description
        }).disposed(by: disposeBag)
        
        ingredientList.subscribe(onNext: { [weak self] list in
            self?.currentIngredientList = list
        }).disposed(by: disposeBag)
    }
    func getData() async{
        do {
            let ingredient: Ingredient = try await NetworkManager.shared.get(.ingredient)
            self.ingredient.accept(ingredient)
        } catch {
            print("Fetch Error", error)
        }
    }
    
    func appendString(_ newString: String, _ newIngredientId: Int) {
        var currentValues = createRecipeIngredient.value
        var currentId = ingredientList.value
        
        currentValues.append(newString)
        currentId.append(newIngredientId)
        
        createRecipeIngredient.accept(currentValues)
        ingredientList.accept(currentId)
    }
    
    func removeString(_ targetString: String, _ newIngredientId: Int) {
        var currentValues = createRecipeIngredient.value
        var currentId = ingredientList.value
        if let index = currentValues.firstIndex(of: targetString), let idx = currentId.firstIndex(of: newIngredientId) {
            currentValues.remove(at: index)
            currentId.remove(at: idx)
            createRecipeIngredient.accept(currentValues)
            ingredientList.accept(currentId)
        }
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
    
    func addVideo(videoURL: URL) async -> UploadResult? {
        print(#function)
        do {
            let result: UploadResult = try await NetworkManager.shared.editActivity(endpoint: .videoUpload, videoURL: videoURL)
            return result
        } catch {
            print("An error occurred: \(error)")
            return nil
            // 에러를 처리합니다.
        }
    }
}
