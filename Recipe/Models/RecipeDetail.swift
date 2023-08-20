//
//  RecipeDetail.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation

struct RecipeDetail: Codable {
    let data: Detail
}

struct Detail: Codable {
    let recipe_id: Int
    let recipe_name: String
    let recipe_description: String
    let cook_time: Int
    let serving_size: Int           /// 인분
    let writtenby: String           /// 닉네임
    let rating: Float
    let created_date: String
    let recipe_thumbnail_img: String
    let ingredients: [RecipeDetailIngredient]
    let stages: [RecipeDetailStages]
    let is_saved: Bool
}

struct RecipeDetailIngredient: Codable {
    let ingredient_id: Int
    let ingredient_name: String
    let ingredient_type: String
    let ingredient_size: Float
    let ingredient_unit: String
    let coupang_product_image: String
    let coupang_product_name: String
    let coupang_product_price: Int
    let coupang_product_url: String
    let is_rocket_delivery: Bool
}

struct RecipeDetailStages: Codable {
    let stage_image_url: String?
    let stage_description: String
}


//struct RecipeDetailIngredientPretty: Codable {
//    let 
//}

struct DetailIngredient1: Hashable {
    let id = UUID()
    let ingredientTitle: String
    let ingredientCount: String
    let seasoningTitle: String
    let seasoningCount: String
}
