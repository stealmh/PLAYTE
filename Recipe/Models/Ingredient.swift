//
//  Ingredient.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation

struct Ingredient: Codable {
    let data: [IngredientInfo]
}

struct IngredientInfo: Codable {
    let ingredient_id: Int
    let ingredient_name: String
    let ingredient_type: String
    let ingredient_unit: String
}
