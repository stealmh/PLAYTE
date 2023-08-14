//
//  KeyChainError.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/14.
//

import Foundation

enum KeyChainError: LocalizedError {
    case unhandledError(status: OSStatus)
    case itemNotFound
    
    var errorDescription: String? {
        switch self {
        case .unhandledError(let status):
            return "KeyChain unhandle Error: \(status)"
        case .itemNotFound:
            return "KeyChain item Not Found"
        }
    }
}
