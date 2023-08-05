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
        layer.borderWidth = 1
        layer.borderColor = UIColor.hexStringToUIColor(hex: "#FF5520").cgColor
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



