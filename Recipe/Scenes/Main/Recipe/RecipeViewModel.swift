//
//  RecipeViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//
import Foundation
import RxSwift
import RxCocoa

class RecipeViewModel {
    var themeRecipe = PublishRelay<Recipe>()
    
    
    func fetchMyInfo(_ sort: Sort) async throws -> Recipe {
        print(#function)
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                LoadingIndicator.showLoading()
            }
            NetworkManager.shared.performRequest(endpoint: .recipes(sort), responseType: Recipe.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                    continuation.resume(returning: data)
                    DispatchQueue.main.async {
                        LoadingIndicator.hideLoading()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        LoadingIndicator.hideLoading()
                    }
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMyInfo(_ sort: Sort) async throws -> Recipe {
        print(#function)
        return try await fetchMyInfo(sort)
    }
    
    func getTheme(_ theme: Theme) async {
        do {
            let data1: Recipe = try await NetworkManager.shared.get(.recipeTheme(theme))
            themeRecipe.accept(data1)
        } catch {
            print("getTheme Error")
        }
    }
}
