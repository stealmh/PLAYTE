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
        layer.borderColor = UIColor.blue.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class RecipeDefaultTagButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("더보기", for: .normal) //title넣기
        setTitleColor(.black, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = .boldSystemFont(ofSize: 12)
        contentHorizontalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


