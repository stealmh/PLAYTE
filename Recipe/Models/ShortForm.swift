//
//  ShortForm.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/28.
//

import Foundation

//MARK: - 숏폼 조회
struct ShortForm: Hashable, Codable {
    let code: String
    let data: ShortFormContent
    
    static func == (lhs: ShortForm, rhs: ShortForm) -> Bool {
        return lhs.data == rhs.data
    }
}

struct ShortFormContent: Hashable, Codable {
    let content: [ShortFormInfo]
    
    static func == (lhs: ShortFormContent, rhs: ShortFormContent) -> Bool {
        return lhs.content == rhs.content
    }
}

struct ShortFormInfo: Hashable, Codable {
    let comments_count: Int
    let created_date: String
    let ingredients: [ShortFormDetailIngredient]
    var is_liked: Bool
    var is_saved: Bool
    var likes_count: Int
    var saved_count: Int
    let shortform_description: String
    let shortform_id: Int
    let shortform_name: String
    let video_time: String
    let video_url: String
    let writtenBy: String
    let writtenid: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(shortform_id)
    }
    static func == (lhs: ShortFormInfo, rhs: ShortFormInfo) -> Bool {
        return lhs.shortform_id == rhs.shortform_id
    }
}

struct ShortFormDetailIngredient: Hashable, Codable {
    let ingredient_id: Int
    let ingredient_name: String
    let ingredient_type: String
    let ingredient_size: Double?
    let ingredient_unit: String
    let coupang_product_image: String
    let coupang_product_name: String
    let coupang_product_price: Int
    let coupang_product_url: String
    let is_rocket_delivery: Bool
}

//MARK: - 숏폼 업로드
struct ShortFormUpload: Codable, Hashable {
    let description: String
    let ingredients_ids: [Int]
    let shortform_name: String
    let video_time: String
    let video_url: String
}
//MARK: - 업로드 결과 받기
struct ShortFormResult: Codable, Hashable {
    let code: String
    let data: Int
    let message: String
}

struct ShortFormDefaultResult: Codable, Hashable {
    let code: String
    let data: Bool
    let message: String
}

struct ShortFormLikeSaveResult: Codable {
    let code: String //4005
    let message: String
}
