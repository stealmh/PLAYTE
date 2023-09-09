//
//  RecipeDetailViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecipeDetailErrorDelegate: AnyObject {
    func noRecipe()
}

class RecipeDetailViewModel {
    
    var ingredient = PublishRelay<RecipeInfo>()
    var recipeDetail = PublishRelay<RecipeDetail>()
    var recipeID: Int = 0
    var writtenID: Int = 0
    weak var delegate: RecipeDetailErrorDelegate?
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
                print("외 에러")
                print(error)
                self.delegate?.noRecipe()
            })
            .disposed(by: disposeBag)
        
        NetworkManager.shared.performRequest(endpoint: .recipeDetail("1"), responseType: RecipeDetail.self) { result in
            switch result {
            case .success(let data):
                print("")
            case .failure(let error):
                print("실행은 되니?")
                          
            }
        }
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
        print(#function)
        print(recipeIngredients[0])
        
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
                    } else if currentIngredient.ingredient_unit == "G" {
                        ingredientType = "g"
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
                    } else if currentIngredient.ingredient_unit == "G" {
                        ingredientType = "g"
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
                if currentIngredient.ingredient_unit == "ML"{
                    ingredientType = "ml"
                } else if currentIngredient.ingredient_unit == "T"{
                    ingredientType = "T"
                }
                let detailIngredient = DetailIngredient(
                    ingredientTitle: "",
                    ingredientCount: "",
                    seasoningTitle: currentIngredient.ingredient_name,
                    seasoningCount: "\(currentIngredient.ingredient_size) \(ingredientType)"
                )
                result.append(detailIngredient)
                index += 1
            }
        }
        return result
    }
    
    
    func report(_ recipeId: Int) async -> DefaultReturnBool? {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.recipeReport("\(recipeId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    
    func notInterest(_ recipeId: Int) async -> DefaultReturnBool? {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.recipeNotInterest("\(recipeId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }

}


