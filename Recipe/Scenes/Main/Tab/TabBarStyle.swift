//
//  TabBarStyle.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

enum TabBarPage {
    case community
    case myPage
    case recipe

    init?(index: Int) {
        switch index {
        case 0:
            self = .recipe
        case 1:
            self = .community
        case 2:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .recipe:
            return "레시피"
        case .community:
            return "커뮤니티"
        case .myPage:
            return "마이페이지"
        }
    }
    
    //tag
    func pageOrderNumber() -> Int {
        switch self {
        case .recipe:
            return 0
        case .community:
            return 1
        case .myPage:
            return 2
        }
    }

    // Add tab icon value
    func tabIcon() -> UIImage {
        switch self {
        case .recipe:
            return UIImage(systemName: "house")!
        case .community:
            return UIImage(systemName: "house")!
        case .myPage:
            return UIImage(systemName: "plus")!
        }
    }
    
    // Add tab icon selected / deselected color
    func selectedImage() -> UIImage {
        switch self {
        case .recipe:
            return UIImage(systemName: "house.fill")!
        case .community:
            return UIImage(systemName: "house.fill")!
        case .myPage:
            return UIImage(systemName: "plus.circle.fill")!
        }
    }
    // etc
}
