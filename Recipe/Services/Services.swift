//
//  Services.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/03.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case responseDataConversionFailed(Error)
    case decodingFailed(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkEndpoint {
    case recipes(_ sortedOption: String)    /// 레시피 목록 조회
    case createRecipe                       /// 레시피 생성
    case deleteMyRecipe(_ recipeId: String) /// 나의 레시피 삭제
    case recipeDetail(_ recipeId: String)   /// 레시피 상세 조회
    case recipeLike(_ recipeId: String)     /// 레시피 좋아요
    case recipeUnLike(_ recipeId: String)   /// 레시피 좋아요 취소
    case recipeSave(_ recipeId: String)     /// 레시피 저장
    case recipeUnSave(_ recipeId: String)   /// 레시피 저장 취소
    case mySaveRecipeSearch                 /// 내가 저장한 레시피 조회
    case myWrittenRecipeSearch              /// 내가 작성한 레시피 조회
    case myInfo                             /// 내정보 조회
    case logout                             /// 로그아웃
    case withdrawal                         /// 회원탈퇴
    case myReviewSearch                     /// 내가 작성한 리뷰 조회
    case ingredient                         /// 재료 목록 조회
    
    var url: String {
        switch self {
        case .recipes(let sortedOption):
            return "https://api.rec1pe.store/api/v1/recipes?sort=\(sortedOption)"
        case .createRecipe:
            return "https://api.rec1pe.store/api/v1/recipes"
        case .deleteMyRecipe(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)"
        case .recipeDetail(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/detail"
        case .recipeLike(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/like"
        case .recipeUnLike(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/unlike"
        case .recipeSave(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/save"
        case .recipeUnSave(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/unsave"
        case .mySaveRecipeSearch:
            return "https://api.rec1pe.store/api/v1/recipes/saved"
        case .myWrittenRecipeSearch:
            return "https://api.rec1pe.store/api/v1/recipes/written"
        case .myInfo:
            return "https://api.rec1pe.store/api/v1/users/me"
        case .logout:
            return "https://api.rec1pe.store/api/v1/auth/logout"
        case .withdrawal:
            return "https://api.rec1pe.store/api/v1/auth/withdrawal"
        case .myReviewSearch:
            return "https://api.rec1pe.store/api/v1/reviews/my"
        case .ingredient:
            return "https://api.rec1pe.store/api/v1/ingredients"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .recipes,
             .recipeDetail,
             .mySaveRecipeSearch,
             .myWrittenRecipeSearch,
             .myInfo,
             .myReviewSearch,
             .ingredient:
            return .get
            
        case .createRecipe,
             .recipeLike,
             .recipeUnLike,
             .recipeSave,
             .recipeUnSave,
             .logout,
             .withdrawal:
            return .post
            
        case .deleteMyRecipe:
            return .delete
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout:
            return ["Authorization": KeyChain.shared.read(account: .accessToken),
                    "Refresh-Token": KeyChain.shared.read(account: .refreshToken),
                    "Content-Type": "application/json"]
        default:
            return ["Authorization": KeyChain.shared.read(account: .accessToken),
                    "Content-Type": "application/json"]
        
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func performRequest<T: Decodable>(endpoint: NetworkEndpoint,
                                      parameters: [String: Any]? = nil, responseType: T.Type,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }
        
        if let headers = endpoint.headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                
                completion(.success(decodedData))
            } catch {
                print("JSON Decoding Error:", error)
                if let response = response as? HTTPURLResponse {
                    print("HTTP Status Code:", response.statusCode)
                }
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print("Response Data:", responseDataString)
                }
                completion(.failure(.responseDataConversionFailed(error)))
            }
        }
        
        task.resume()
    }
    
    
    private func fetch<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
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
