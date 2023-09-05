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
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .grayScale6
        return v
    }()
    
    private let timeImageVIew: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "time_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    private let cookTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews(recipeImageView,
                    recipeTitle,
                    cookTimeLabel,timeImageVIew)
        
        self.setUI()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        clipsToBounds = true
        mock()
    }
    
    func configure(_ data: Recommendation) {
        DispatchQueue.main.async {
            self.recipeImageView.loadImage(from: data.img_url)
            self.recipeTitle.text = data.recipe_name
            self.cookTimeLabel.text = "조리시간 \(data.cooking_time)분"
        }
    }
    
    func configureForMyPage(_ data: RecipeInfo) {
        DispatchQueue.main.async {
            self.recipeImageView.backgroundColor = .grayScale3
            self.recipeImageView.loadImage(from: data.recipe_thumbnail_img)
            self.recipeTitle.text = data.recipe_name
            self.cookTimeLabel.text = "조리시간 \(data.cook_time)분"
            self.recipeImageView.backgroundColor = .white
        }
    }
    
    func setUI() {
        recipeImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(130)
            $0.width.equalToSuperview()
        }
        
        recipeTitle.snp.makeConstraints {
            $0.top.equalTo(recipeImageView.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(15)
            $0.right.equalToSuperview()
        }

        timeImageVIew.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(3)
            $0.left.equalTo(recipeTitle)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(5)
            $0.left.equalTo(timeImageVIew.snp.right)
            $0.width.equalToSuperview()
        }
    }
    
    func mock() {
        recipeImageView.loadImage(from: "https://d1jg55wkcrciwu.cloudfront.net/images/a5838556-94f1-4602-aa83-3035fa340b94.jpeg")
        recipeTitle.text = "한번만 맛본사람이 없는 맛돌이"
        cookTimeLabel.text = "조리시간 10분"
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
            .previewLayout(.fixed(width: 173, height: 200))
    }
}
#endif
