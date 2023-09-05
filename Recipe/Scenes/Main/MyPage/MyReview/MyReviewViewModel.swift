//
//  MyReviewViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/20.
//

import Foundation
import RxSwift
import RxCocoa

class MyReviewViewModel {
    
    var myReview: MyReview?
    var myReviewRelay = BehaviorRelay<[MyReviewList]>(value: [])
    
    func getData() async {
        do {
            let myReview: MyReview = try await NetworkManager.shared.get(.myReviewSearch)
            self.myReview = myReview
            myReviewRelay.accept(myReview.data)
        } catch {
            print("Fetch Error", error)
        }
    }
}
