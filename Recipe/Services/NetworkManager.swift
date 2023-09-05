//
//  Services.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/03.
//

import Foundation
import Alamofire
import UIKit

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
                print(String(data: data!, encoding: .utf8))
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
    
    func performMultipartRequest<T: Decodable>(
        endpoint: NetworkEndpoint,
        parameters: [String: Any]? = nil,
        image: UIImage? = nil,
        imageKey: String = "image",
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        if let headers = endpoint.headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        var body = Data()
        
        // Add parameters
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"multipartFile\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        // Add image
        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"multipartFile\"; filename=\"\(imageKey).jpg\"\r\n") // 변경된 부분
            body.append("Content-Type: image/jpg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        print("================================================")
        print(String(data: data, encoding: .utf8))
        print("================================================")
        let decodedData = try decoder.decode(T.self, from: data)
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            print("HTTP Status Code:", response.statusCode)
            if let responseDataString = String(data: data, encoding: .utf8) {
                print("Response Data:", responseDataString)
            }
            throw NetworkError.responseDataConversionFailed(NSError(domain: "", code: response.statusCode, userInfo: nil))
        }
        
        return decodedData
    }
    
    func editActivity<T: Decodable>(endpoint: NetworkEndpoint, imageData: UIImage?) async throws -> T {

        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }

        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": KeyChain.shared.read(account: .accessToken)
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                if let image = imageData?.jpegData(compressionQuality: 0.1) {
                    multipartFormData.append(image, withName: "multipartFile", fileName: "uploaded_image.jpg", mimeType: "image/jpg")
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(T.self, from: data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func editActivity<T: Decodable>(endpoint: NetworkEndpoint, videoURL: URL) async throws -> T {
        print(#function)
        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }

        guard let videoData = try? Data(contentsOf: videoURL) else {
            throw NetworkError.invalidDataConversion
        }

        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": KeyChain.shared.read(account: .accessToken)
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(videoData, withName: "multipartFile", fileName: "uploaded_video.mov", mimeType: "video/quicktime")
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(T.self, from: data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetch<T: Decodable>(_ endpoint: NetworkEndpoint, parameters: [String: Any]? = nil) async throws -> T {
        print(#function)
        return try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.performRequest(endpoint: endpoint, parameters: parameters, responseType: T.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                    continuation.resume(returning: data)
                case .failure(let error):
                    print("ERROR For #fetch")
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func get<T: Decodable>(_ endpoint: NetworkEndpoint, parameters: [String: Any]? = nil) async throws -> T {
        print(#function)
        return try await fetch(endpoint, parameters: parameters)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
