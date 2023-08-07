//
//  RecipeDefaultTagButton.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/05.
//

import UIKit

class RecipeDefaultTagButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(tagName: String, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        self.setTitle(tagName, for: .normal)
        setTitleColor(.mainColor, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = .boldSystemFont(ofSize: 12)
        contentHorizontalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
