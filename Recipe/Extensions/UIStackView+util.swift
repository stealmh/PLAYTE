//
//  UIStackView+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/12.
//

import UIKit

extension UIStackView {
    func addArrangeViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
