//
//  SearchRecipeViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRecipeViewModel {
    var popularKeyword = PublishRelay<Search>()
    var searchRecipe = PublishRelay<Recipe>()
    var themeRecipe = PublishRelay<(Recipe, Theme)>()
    
    func setData() async {
        do {
            let data1: Search = try await NetworkManager.shared.get(.searchKeyword)
            popularKeyword.accept(data1)
        } catch {
            print("SearchRecipeViewModel setData() Error")
        }
    }
    
    func searchRecipe(_ keyword: String) async {
        do {
            let data2: Recipe = try await NetworkManager.shared.get(.searchRecipe(keyword))
            searchRecipe.accept(data2)
        } catch {
            print("searchRecipe Error")
        }
    }
}
