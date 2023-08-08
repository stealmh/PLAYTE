//
//  RecipeDefaultTag.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit

class RecipeDefaultTagView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        clipsToBounds = true
        backgroundColor = .sub1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



