//
//  KeyChain.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/14.
//

import Foundation
import Security

final class KeyChain {
    
    static let shared = KeyChain()
    static let serviceName = Bundle.main.bundleIdentifier
    
    private init() { }
    
    func create(account: KeyChainAccount, data: String) {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChain.serviceName,
            kSecAttrAccount: account.description,
            kSecValueData: (data as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ] as CFDictionary
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
//        guard status == noErr else {
//            throw KeyChainError.unhandledError(status: status)
//        }
    }
    
    func read(account: KeyChainAccount) -> String {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChain.serviceName,
            kSecAttrAccount: account.description,
            kSecReturnData: true
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
//        guard status != errSecItemNotFound else {
//            throw KeyChainError.itemNotFound
//        }
        
        if status == errSecSuccess,
           let item = dataTypeRef as? Data,
           let data = String(data: item, encoding: String.Encoding.utf8) {
            return data
        } else {
//            throw KeyChainError.unhandledError(status: status)
            return ""
        }
    }
    
    func delete(account: KeyChainAccount) {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChain.serviceName,
            kSecAttrAccount: account.description
        ] as CFDictionary
        
//        let status = SecItemDelete(query)
        SecItemDelete(query)
        
//        guard status == errSecSuccess || status == errSecItemNotFound else {
//            throw KeyChainError.unhandledError(status: status)
//        }
    }
}
