//
//  CreateRecipeViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation
import RxSwift
import RxCocoa

class CreateRecipeViewModel {
    
    var ingredient = PublishRelay<Ingredient>()
    private var disposeBag = DisposeBag()
    
    func getData() async{
        do {
            let ingredient: Ingredient = try await NetworkManager.shared.get(.ingredient)
            self.ingredient.accept(ingredient)
        } catch {
            print("Fetch Error", error)
        }
    }
}
