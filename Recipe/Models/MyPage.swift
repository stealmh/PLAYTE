//
//  MyPage.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation

struct MyInfo1: Codable, Hashable {
    let data: MyDetailInfo
    
    static func == (lhs: MyInfo1, rhs: MyInfo1) -> Bool {
        return lhs.data == rhs.data
    }
}

struct MyDetailInfo: Codable, Hashable {
    let memberId: Int
    let email: String
    let nickname: String
    let provider: String
}

extension MyDetailInfo {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(memberId)
    }
    static func == (lhs: MyDetailInfo, rhs: MyDetailInfo) -> Bool {
        return lhs.memberId == rhs.memberId
    }
    
}
