//
//  RecipeUploadResult.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/26.
//

import Foundation

struct RecipeUploadResult: Codable {
    let code: String
    let data: Int
    let message: String
}

