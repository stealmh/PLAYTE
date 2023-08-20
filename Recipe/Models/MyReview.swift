//
//  MyReview.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation

struct MyReview: Decodable {
    let code: String
    let data: [MyReviewList]
}

struct MyReviewList: Decodable {
    let img_list: [String]
    let recipe_name: String
    let review_content: String
    let review_rating: Int
    let written_date: String
}
