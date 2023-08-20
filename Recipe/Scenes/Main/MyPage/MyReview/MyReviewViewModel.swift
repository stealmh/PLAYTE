//
//  MyReviewViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation

class MyReviewViewModel {
    
    var myReview: MyReview?
    
    func getData() async {
        do {
            let myReview: MyReview = try await NetworkManager.shared.get(.myReviewSearch)
            print(myReview)
            self.myReview = myReview
        } catch {
            print("Fetch Error", error)
        }
    }
}
