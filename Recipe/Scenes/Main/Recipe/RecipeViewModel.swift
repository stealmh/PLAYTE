//
//  RecipeViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//
import Foundation

class RecipeViewModel {
    func fetchMyInfo() async throws -> Recipe {
        print(#function)
        return try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.performRequest(endpoint: .recipes(.popular), responseType: Recipe.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                    continuation.resume(returning: data)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMyInfo() async throws -> Recipe {
        print(#function)
        return try await fetchMyInfo()
    }
}
