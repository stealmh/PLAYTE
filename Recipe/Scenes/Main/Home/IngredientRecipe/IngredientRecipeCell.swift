//
//  MyRecipeCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit

class IngredientRecipeCell: UICollectionViewCell {
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    private let recipeTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 15)
        return v
    }()
    private let cookTimeLabel = UILabel()
    
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
            $0.width.equalToSuperview()
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(5)
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
            .previewLayout(.fixed(width: 150, height: 200))
    }
}
#endif
