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
    
    func appleRegister(idToken: String, nickName: String){
        print(#function)
        let url = "https://api.rec1pe.store/api/v1/auth/apple/signup"
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let bodyData : Parameters = [
            "idToken" : idToken,
            "nickname": nickName
        ]

//        print(idToken, nickName)
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
                    guard let decodedData = try? decoder.decode(LoginTokenInfo.self, from: res) else {
                        print("LoginTokenInfo Type Decoded Error")
                        print(String(data: res, encoding: .utf8)!)
                        print(res)
                        return
                    }
                    print(decodedData)
                    KeyChain.shared.create(account: .accessToken, data: decodedData.data.accessToken)
                    KeyChain.shared.create(account: .refreshToken, data: decodedData.data.refreshToken)
                    self.appleLogin(accessToken: KeyChain.shared.read(account: .accessToken))
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
    func appleLogin(accessToken: String) {
        print(#function)
        let url = "https://api.rec1pe.store/api/v1/auth/apple/signin"
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let bodyData : Parameters = [
            "idToken" : accessToken,
        ]
        print(accessToken)
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
                    guard let decodedData = try? decoder.decode(LoginSucess.self, from: res) else {
                        print("LoginSucess Type Decoded Error")
                        print(res)
                        return
                    }
                    print(decodedData)
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
                    print(decodedData.message)
                    print(decodedData.data.isDuplicated)
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
