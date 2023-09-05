//
//  Review.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import Foundation

//MARK: 레시피 상단 별점
struct ReviewStar: Codable, Hashable {
    let code: String
    let data: StarPoint
}

struct StarPoint: Codable, Hashable {
    let fivePoint: Int
    let fourPoint: Int
    let threePoint: Int
    let twoPoint: Int
    let onePoint: Int
    let totalRating: Double
}
//MARK: - 레시피 상단 사진들
struct ReviewPhoto: Codable, Hashable {
    let code: String
    let data: [String]
}
//MARK: - 레시피 하단 리뷰 목록들
struct ReviewList: Codable, Hashable {
    let code: String
    let data: ReviewContents
}

struct ReviewContents: Codable, Hashable {
    let content: [ReviewInfo]
    let empty: Bool
    let first: Bool
    let last: Bool
}

struct ReviewInfo: Codable, Hashable {
    let like_count: Int
    let liked: Bool
    let modified_at: String
    let rating: Double
    let review_content: String
    let review_id: Int
    let review_images: [String]
    let review_title: String
    let writtenby: String
}

//MARK: - 리뷰 좋아요/좋아요취소/신고 결과
struct ReviewResult: Codable, Hashable {
    let code: String
//    let data: Int
    let message: String
}

//MARK: - 리뷰 작성
struct AddReview: Codable, Hashable {
    let review_content: String
    let review_imgs: [String]
    let review_rating: Int
}

struct RecipeComment: Codable, Hashable {
    let code: String
    var data: CommentContents
}

struct CommentContents: Codable, Hashable {
    var content: [CommentInfo]
}

struct CommentInfo: Codable, Hashable {
    var comment_content: String
    let comment_id: Int
    var comment_likes: Int
    let comment_writtenby: String
    let created_at: String
    var is_liked: Bool
    var replyList: [ReplyList]
}

struct ReplyList: Codable, Hashable {
    let created_at: String
    var is_likes: Bool
    var reply_content: String
    let reply_id: Int
    var reply_likes: Int
    let reply_writtenby: String
}
