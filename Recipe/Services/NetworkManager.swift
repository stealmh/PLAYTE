//
//  Services.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/03.
//

import Foundation

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
