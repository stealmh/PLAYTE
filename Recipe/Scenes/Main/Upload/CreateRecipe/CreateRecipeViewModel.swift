//
//  CreateRecipeViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa


struct UploadRecipe: Hashable, Encodable {
    let cook_time: Int
    let ingredients: [UploadRecipeIngredient]
    let recipe_description: String
    let recipe_name: String
    let recipe_stages: [RecipeUploadForStep]
    let recipe_thumbnail_img: String
    let serving_size: Int
}

struct RecipeUploadForStep: Hashable, Encodable {
    let image_url: String?
    let stage_description: String
}

struct UploadRecipeIngredient: Hashable, Encodable {
    let ingredient_id: Int
    let ingredient_size: Int
}

class CreateRecipeViewModel {
    //    var addIngredientMockData: [String] = []
    var imageRelay = PublishRelay<UIImage>()
    var imageBehaviorRelay = BehaviorRelay<UIImage?>(value: nil)
    var thumbnailImage = BehaviorRelay<UIImage?>(value:nil)
    var createRecipeTitle = PublishRelay<String>()
    var createRecipeDescription = PublishRelay<String>()
    var createRecipeCookTime = PublishRelay<Int>()
    var createRecipeServiceCount = PublishRelay<Int>()
    
    /// UI 보여주기용
    var createRecipeIngredient = BehaviorRelay<[String]>(value: [])
    /// JsonBody 용
    var getIngredient = BehaviorRelay<[UploadRecipeIngredient]>(value: [])
    var createRecipeCookStep = BehaviorRelay<[RecipeUploadForStep]>(value: [])
    var ingredient = PublishRelay<Ingredient>()
    var upload = PublishRelay<UploadRecipe>()
    var uploadCheck = PublishRelay<Bool>()
    
    let allValuesSubject = PublishSubject<(UIImage?, String, String, Int, Int, [UploadRecipeIngredient])>()
    private var disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(
            thumbnailImage.asObservable(),
            createRecipeTitle.asObservable(),
            createRecipeDescription.asObservable(),
            createRecipeCookTime.asObservable(),
            createRecipeServiceCount.asObservable(),
            getIngredient.asObservable()
        )
        .bind(to: allValuesSubject)
        .disposed(by: disposeBag)
    }
    
    func getData() async{
        do {
            let ingredient: Ingredient = try await NetworkManager.shared.get(.ingredient)
            self.ingredient.accept(ingredient)
        } catch {
            print("Fetch Error", error)
        }
    }
    
    func appendString(_ newString: String) {
        var currentValues = createRecipeIngredient.value
        currentValues.append(newString)
        createRecipeIngredient.accept(currentValues)
    }
    
    func addIngredient(_ step: UploadRecipeIngredient) {
        var currentValues = getIngredient.value
        currentValues.append(step)
        getIngredient.accept(currentValues)
    }
    
    func removeIngredient(_ idx: Int) {
        var currentValues = getIngredient.value
    
        for (i,item) in currentValues.enumerated() {
            if item.ingredient_id == idx {
                currentValues.remove(at: i)
                getIngredient.accept(currentValues)
                return
            }
        }
    }
    
    func removeString(_ name: String) {
        var currentValues = createRecipeIngredient.value
        
        for (i, item) in currentValues.enumerated() {
            if item == name {
                currentValues.remove(at: i)
                createRecipeIngredient.accept(currentValues)
                return
            }
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
    
}
