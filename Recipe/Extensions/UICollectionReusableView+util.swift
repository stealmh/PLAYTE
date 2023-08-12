//
//  UICollectionReusableView+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit

//UICollectionViewCell + UICollectionReusableView
extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}


extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
