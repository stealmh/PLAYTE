//
//  Recipe.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation

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
    let rating: Int
    let recipe_id: Int
    let recipe_name: String
    let recipe_thumbnail_img: String
    
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
    let created_date: String
    let image_url: String
    let is_saved: Bool
    let nickname: String
    let rating: Int
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
