//
//  TabBarStyle.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

enum TabBarPage {
    case home
    case myPage

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "홈"
        case .myPage:
            return "마이페이지"
        }
    }
    
    //tag
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .myPage:
            return 1
        }
    }

    // Add tab icon value
    func tabIcon() -> UIImage {
        switch self {
        case .home:
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
        case .myPage:
            return UIImage(systemName: "plus.circle.fill")!
        }
    }
    // etc
}
