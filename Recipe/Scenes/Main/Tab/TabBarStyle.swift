//
//  TabBarStyle.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

enum TabBarPage {
    case home
    case community
    case myPage
    case recipe

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .recipe
        case 2:
            self = .community
        case 3:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "홈"
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
        case .home:
            return 0
        case .recipe:
            return 1
        case .community:
            return 2
        case .myPage:
            return 3
        }
    }

    // Add tab icon value
    func tabIcon() -> UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
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
        case .home:
            return UIImage(systemName: "house.fill")!
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
