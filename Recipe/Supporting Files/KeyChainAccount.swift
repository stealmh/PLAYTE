//
//  KeyChainAccount.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/14.
//

import Foundation

enum KeyChainAccount {
    case idToken
    case accessToken
    case refreshToken
    case accesstokenExpiredTime
    case refreshTokenExpiredTime
    case loginType
    
    var description: String {
        return String(describing: self)
    }
    
    var keyChainClass: CFString { return kSecClassGenericPassword }
}
