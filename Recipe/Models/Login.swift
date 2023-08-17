//
//  Login.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/14.
//

import Foundation

struct Welcome: Codable {
    let code: String
    let data: DataClass
    let message: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let isDuplicated: Bool
}

struct LoginTokenInfo: Codable {
    let code: String
    let message: String
    let data: Token
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}

struct LoginSucess: Codable {
    let code: String
    let data: LoginInfo
}

struct LoginInfo: Codable {
    let isMember: Bool
    let jwtTokens: Token
}


struct MemberCheck: Codable {
    let code: String
    let data: Member
}

struct Member: Codable {
    let isMember: Bool
}
