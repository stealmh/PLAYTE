//
//  MyPageViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation

class MyPageViewModel {
    func fetchMyInfo() async throws -> MyInfo1 {
        print(#function)
        return try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.performRequest(endpoint: .myInfo, responseType: MyInfo1.self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMyInfo() async throws -> MyInfo1 {
        print(#function)
        return try await fetchMyInfo()
    }
    
    func fetch<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        print(#function)
        return try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.performRequest(endpoint: endpoint, responseType: T.self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func get<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        print(#function)
        return try await fetch(endpoint)
    }
}
