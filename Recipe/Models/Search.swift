//
//  Search.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import Foundation


//MARK: - 인기검색어
struct Search: Codable, Hashable {
    let code: String
    let data: [String]
}

