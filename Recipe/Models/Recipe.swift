//
//  Recipe.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation

//MARK: - 레시피 탭바의 아이템 리스트들, 레시피 검색했을 때 레시피 리스트들에 사용하는 모델
struct Recipe: Codable, Hashable {
    let code: String
    let data: Contents
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.data == rhs.data
    }
}

struct Contents: Codable, Hashable {
    let content: [RecipeInfo]
    
    static func == (lhs: Contents, rhs: Contents) -> Bool {
        return lhs.content == rhs.content
    }
}

struct RecipeInfo: Codable, Hashable {
    let comment_count: Int
    let created_date: String
    let is_saved: Bool
    let nickname: String
    let rating: Float
    let recipe_id: Int
    let recipe_name: String
    let recipe_thumbnail_img: String
    let cook_time: Int
    let writtenid: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(recipe_id)
    }
    static func == (lhs: RecipeInfo, rhs: RecipeInfo) -> Bool {
        return lhs.recipe_id == rhs.recipe_id
    }
}


struct Recipe1: Codable, Hashable {
    let code: String
    let data: [RecipeInfo1]
    
    static func == (lhs: Recipe1, rhs: Recipe1) -> Bool {
        return lhs.data == rhs.data
    }
}

struct RecipeInfo1: Codable, Hashable {
    let comment_count: Int
    let cook_time: Int
    let created_date: String
    let is_saved: Bool
    let nickname: String
    let rating: Float
    let recipe_id: Int
    let recipe_name: String
    let recipe_thumbnail_img: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(recipe_id)
    }
    static func == (lhs: RecipeInfo1, rhs: RecipeInfo1) -> Bool {
        return lhs.recipe_id == rhs.recipe_id
    }
}

/// data가 id값을 반환해야 할 때
struct DefaultReturnID: Codable, Hashable {
    let code: String
    let data: Int
    let message: String
}

/// data가 String을 반환해야 할 때
struct DefaultReturnString: Codable, Hashable {
    let code: String
    let data: String
    let message: String
}

/// data가 Bool값을 반환해야 할 때
struct DefaultReturnBool: Codable, Hashable {
    let code: String
    let data: Bool
    let message: String
}

// str = 4005 이면 이미 저장된 레시피
struct DefaultOnlyCodeMessage: Codable {
    let code: String
    let message: String
}
