//
//  MyRecipeCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit

final class IngredientRecipeCell: UICollectionViewCell {
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
//        v.layer.cornerRadius = 10
//        v.clipsToBounds = true
        return v
    }()
    private let recipeTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        return v
    }()
    private let cookTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .gray.withAlphaComponent(0.6)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews(recipeImageView,
                    recipeTitle,
                    cookTimeLabel)
        
        self.setUI()
        self.configure(IngredientRecipe(image: UIImage(named: "popcat")!,
                                     title: "토마토 계란볶음밥",
                                     cookTime: "조리 시간 10분"))
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        clipsToBounds = true
    }
    
    func configure(_ data: IngredientRecipe) {
        recipeImageView.image = data.image
        recipeTitle.text = data.title
        cookTimeLabel.text = data.cookTime
    }
    
    func setUI() {
        recipeImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(130)
            $0.width.equalToSuperview()
        }
        
        recipeTitle.snp.makeConstraints {
            $0.top.equalTo(recipeImageView.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(10)
            $0.width.equalToSuperview()
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(5)
            $0.left.equalTo(recipeTitle)
            $0.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#if DEBUG
import SwiftUI
struct ForIngredientRecipeCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        IngredientRecipeCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForIngredientRecipeCellPreview: PreviewProvider {
    static var previews: some View {
        ForIngredientRecipeCell()
            .previewLayout(.fixed(width: 173, height: 180))
    }
}
#endif
