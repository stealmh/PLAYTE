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
    func postBodyJsonRequest(){
        // [http 요청 주소 지정]
        let url = "https://api.rec1pe.store/api/v1/auth/apple/signin"
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        // [http 요청 파라미터 지정 실시]
        let bodyData : Parameters = [
            "email" : "kmh922@naver.com",
            "idToken" : "test",
            "nickname": "뽀삐"
        ]
        // [http 요청 수행 실시]
        print("")
        print("====================================")
//        print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 요청 실시]")
        print("-------------------------------")
        print("주 소 :: ", url)
        print("-------------------------------")
        print("데이터 :: ", bodyData.description)
        print("====================================")
        print("")
        
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
                    print("")
                    print("====================================")
//                    print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 응답 확인]")
                    print("-------------------------------")
                    print("응답 코드 :: ", response.response?.statusCode ?? 0)
                    print("-------------------------------")
                    print("응답 데이터 :: ", String(data: res, encoding: .utf8) ?? "")
                    print("====================================")
                    print("")
                    // [비동기 작업 수행]
                    DispatchQueue.main.async {
                    }
                }
                catch (let err){
                    print("")
                    print("====================================")
//                    print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 응답 확인]")
                    print("-------------------------------")
                    print("catch :: ", err.localizedDescription)
                    print("====================================")
                    print("")
                }
                break
            case .failure(let err):
                print("")
                print("====================================")
//                print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 요청 실패]")
                print("-------------------------------")
                print("응답 코드 :: ", response.response?.statusCode ?? 0)
                print("-------------------------------")
                print("에 러 :: ", err.localizedDescription)
                print("====================================")
                print("")
                break
            }
        }
    }
}
