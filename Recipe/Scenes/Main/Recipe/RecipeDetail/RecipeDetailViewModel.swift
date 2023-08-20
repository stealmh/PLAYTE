//
//  RecipeDetailViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation
import RxSwift
import RxCocoa

class RecipeDetailViewModel {
    
    var ingredient = PublishRelay<RecipeInfo>()
    var recipeDetail = PublishRelay<RecipeDetail>()
    private var disposeBag = DisposeBag()

    init() {
        getData()
        getIngredient()
    }
    func getData() {
        print(#function)
        ingredient
            .flatMapLatest { data -> Observable<RecipeDetail> in
                return Observable.create { observer in
                    Task {
                        do {
                            let recipeDetail: RecipeDetail = try await NetworkManager.shared.get(.recipeDetail("\(data.recipe_id)"))
                            print("============================================================")
                            print("recipeInfo: \(recipeDetail)")
                            observer.onNext(recipeDetail)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { recipeDetail in
                // Handle the recipeInfo data here
                self.recipeDetail.accept(recipeDetail)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getIngredient() {
        recipeDetail
            .subscribe(onNext: { data in
                let value = self.combineIngredients(data.data.ingredients)
                print("=====================================================")
                print(value)
                print("=====================================================")
            }).disposed(by: disposeBag)
    }
    
    func combineIngredients(_ recipeIngredients: [RecipeDetailIngredient]) -> [DetailIngredient] {
        var result: [DetailIngredient] = []
        
        var index = 0
        var ingredientType: String = ""
        
        while index < recipeIngredients.count {
            let currentIngredient = recipeIngredients[index]
            
            if currentIngredient.ingredient_type == "INGREDIENTS" {
                var sauceFound: RecipeDetailIngredient? = nil
                for i in (index + 1)..<recipeIngredients.count {
                    if recipeIngredients[i].ingredient_type == "SAUCE" {
                        sauceFound = recipeIngredients[i]
                        break
                    }
                }
                
                if let sauce = sauceFound {
                    if currentIngredient.ingredient_unit == "PIECE"{
                        ingredientType = "개"
                    }
                    let detailIngredient = DetailIngredient(
                        ingredientTitle: currentIngredient.ingredient_name,
                        ingredientCount: "\(Int(currentIngredient.ingredient_size)) \(ingredientType)",
                        seasoningTitle: sauce.ingredient_name,
                        seasoningCount: "\(sauce.ingredient_size) \(sauce.ingredient_unit)"
                    )
                    result.append(detailIngredient)
                    index += 2
                } else {
                    if currentIngredient.ingredient_unit == "PIECE"{
                        ingredientType = "개"
                    }
                    let detailIngredient = DetailIngredient(
                        ingredientTitle: currentIngredient.ingredient_name,
                        ingredientCount: "\(Int(currentIngredient.ingredient_size)) \(ingredientType)",
                        seasoningTitle: "",
                        seasoningCount: ""
                    )
                    result.append(detailIngredient)
                    index += 1
                }
            } else if currentIngredient.ingredient_type == "SAUCE" {
                let detailIngredient = DetailIngredient(
                    ingredientTitle: "",
                    ingredientCount: "",
                    seasoningTitle: currentIngredient.ingredient_name,
                    seasoningCount: "\(currentIngredient.ingredient_size) \(currentIngredient.ingredient_unit)"
                )
                result.append(detailIngredient)
                index += 1
            }
        }
        return result
    }

}


