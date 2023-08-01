//
//  TabBarStyle.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

enum TabBarPage {
    case shortForm
    case recipe
    case upload
    case myPage

    init?(index: Int) {
        switch index {
        case 0:
            self = .shortForm
        case 1:
            self = .recipe
        case 2:
            self = .upload
        case 3:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .shortForm:
            return "숏폼"
        case .recipe:
            return "레시피"
        case .upload:
            return "업로드"
        case .myPage:
            return "마이페이지"
        }
    }
    
    //tag
    func pageOrderNumber() -> Int {
        switch self {
        case .shortForm:
            return 0
        case .recipe:
            return 1
        case .upload:
            return 2
        case .myPage:
            return 3
        }
    }

    // Add tab icon value
    func tabIcon() -> UIImage {
        switch self {
        case .shortForm:
            return UIImage(named: "shortform")!
        case .recipe:
            return UIImage(named: "recipe")!
        case .upload:
            return UIImage(named: "upload")!
        case .myPage:
            return UIImage(named: "mypage")!
        }
    }
    
    // Add tab icon selected / deselected color
    func selectedImage() -> UIImage {
        switch self {
        case .shortForm:
            return UIImage(named: "shortform.fill")!
        case .recipe:
            return UIImage(named: "recipe.fill")!
        case .upload:
            return UIImage(named: "upload.fill")!
        case .myPage:
            return UIImage(named: "mypage.fill")!
        }
    }
    // etc
}
