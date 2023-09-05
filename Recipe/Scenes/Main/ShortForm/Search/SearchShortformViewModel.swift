//
//  SearchShortformViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//
import RxSwift
import RxCocoa

class SearchShortformViewModel {
    var popularKeyword = PublishRelay<Search>()
    var shortform = PublishRelay<ShortForm>()
    
    func setData() async {
        do {
            let data1: Search = try await NetworkManager.shared.get(.searchKeyword)
            popularKeyword.accept(data1)
        } catch {
            print("SearchRecipeViewModel setData() Error")
        }
    }
    
    func searchShortform(_ keyword: String) async {
        do {
            let data2: ShortForm = try await NetworkManager.shared.get(.searchShortForm(keyword))
            shortform.accept(data2)
        } catch {
            print("searchRecipe Error")
        }
    }
}
