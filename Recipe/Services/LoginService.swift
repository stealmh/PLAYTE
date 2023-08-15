//
//  LoginService.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/18.
//

import Foundation
import Alamofire

struct LoginService{
    static let shared = LoginService()

    // MARK: - [Post Body Json Request 방식 http 요청 실시]
    
    func appleRegister(idToken: String, nickName: String, completion: @escaping (Result<LoginSucess, Error>) -> Void) {
        print(#function)
        let url = URL(string: "https://api.rec1pe.store/api/v1/auth/apple/signup")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "idToken" : idToken,
            "nickname": nickName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("parameter Error")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("dataTask Error")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("invalidResponse Error")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(LoginTokenInfo.self, from: data)
                print(decodedData)
                KeyChain.shared.create(account: .accessToken, data: decodedData.data.accessToken)
                KeyChain.shared.create(account: .refreshToken, data: decodedData.data.refreshToken)
                
                // Assuming self.appleLogin is a synchronous function
//                self.appleLogin(accessToken: KeyChain.shared.read(account: .idToken))
                
                DispatchQueue.main.async {
                    // You might call the completion handler here to signal success
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func appleRegister(idToken: String, nickName: String) async throws -> LoginTokenInfo {
        let url = URL(string: "https://api.rec1pe.store/api/v1/auth/apple/signup")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "idToken" : idToken,
            "nickname": nickName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(LoginTokenInfo.self, from: data)
            KeyChain.shared.create(account: .accessToken, data: decodedData.data.accessToken)
            KeyChain.shared.create(account: .refreshToken, data: decodedData.data.refreshToken)
            
            // Assuming self.appleLogin is a synchronous function
    //        self.appleLogin(accessToken: KeyChain.shared.read(account: .idToken))
            
            return decodedData
        } catch {
            throw error
        }
    }
    
    func appleLogin(accessToken: String, completion: @escaping (Result<LoginSucess, Error>) -> Void) {
        let url = URL(string: "https://api.rec1pe.store/api/v1/auth/apple/signin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "idToken" : accessToken,
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(LoginSucess.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - [Post Body Json Request 방식 http 요청 실시]
    func nickNameCheck(nickName: String, completion: @escaping (_ data: Bool) -> Void){
        print(#function)
        // [http 요청 주소 지정]
        let url = "https://api.rec1pe.store/api/v1/users/verify-nickname"
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        // [http 요청 파라미터 지정 실시]
        let bodyData : Parameters = [
            "nickname" : nickName
        ]
        
        AF.request(
            url, // [주소]
            method: .post, // [전송 타입]
            parameters: bodyData, // [전송 데이터]
            encoding: JSONEncoding.default, // [인코딩 스타일]
            headers: header // [헤더 지정]
        )
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let res):
                do {
                    let decoder = JSONDecoder()
                    guard let decodedData = try? decoder.decode(Welcome.self, from: res) else {
                        print("catch")
                        return
                    }
                    completion(decodedData.data.isDuplicated)
                    // [비동기 작업 수행]
                    DispatchQueue.main.async {
                    }
                }
                catch (let err){
                    print("catch :: ", err.localizedDescription)
                }
                break
            case .failure(let err):
                print("응답 코드 :: ", response.response?.statusCode ?? 0)
                print("에 러 :: ", err.localizedDescription)
                break
            }
        }
    }
    
}
