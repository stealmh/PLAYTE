//
//  Home.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit

struct Refrigerator: Hashable {
    let id = UUID()
    let view: UIView
}

struct IngredientRecipe: Hashable {
    let id = UUID()
    let image: UIImage
    let title: String
    let cookTime: String
}

struct PriceTrend: Hashable {
    let id = UUID()
    let title: String
    let tagName: String
    let date: String
    let transition: String
    let count: Int
    let price: Int
}

struct IngredientsHandle: Hashable {
    let id = UUID()
    let image: UIImage
    let title: String
    let contents: String
}
