//
//  ReviewViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewViewModel {
    var reviewStar = PublishRelay<StarPoint>()
    var photos = PublishRelay<ReviewPhoto>()
    var review = PublishRelay<ReviewList>()
    var comment = PublishRelay<RecipeComment>()
    
    func setData(_ id: Int) async {
        do {
            let data: ReviewStar = try await NetworkManager.shared.get(.recipeScores("\(id)"))
            reviewStar.accept(data.data)
            
            let data2: ReviewPhoto = try await NetworkManager.shared.get(.recipeReviewPhoto("\(id)"))
            photos.accept(data2)
            
            let data3: ReviewList = try await NetworkManager.shared.get(.recipeReview("\(id)", .popular))
            review.accept(data3)
            
            let data4: RecipeComment = try await NetworkManager.shared.get(.recipeComment("\(id)"))
            comment.accept(data4)
        } catch {
            print("setData Error")
        }
    }
}
 
