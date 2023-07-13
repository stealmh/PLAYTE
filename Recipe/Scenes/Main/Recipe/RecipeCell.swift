//
//  RecipeCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import SnapKit

struct Recipe: Hashable {
    let image: UIImage
    let title: String
    let tag: String
    let isFavorite: Bool
    let cookTime: String
}

final class RecipeCell: UICollectionViewCell {
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    private let recipeTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 15)
        return v
    }()
    
    private let favoriteButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "bookmark.fill", size: 30)
        v.setImage(img, for: .normal)
        return v
    }()
    private let tagLabel = UILabel()
    private let cookTimeLabel: UIButton = {
        let v = UIButton()
        v.setTitle("10분", for: .normal)
        v.setImage(UIImage(systemName: "stopwatch"), for: .normal)
        v.tintColor = .black
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews(recipeImageView,
                    recipeTitle,
                    tagLabel,favoriteButton,cookTimeLabel)
        
        self.setUI()

    }
    
    func configure(_ data: Recipe) {
        recipeImageView.image = data.image
        recipeTitle.text = data.title
        tagLabel.text = data.tag
        favoriteButton.setImage(
            data.isFavorite ? UIImage(systemName: "bookmark.fill")! : UIImage(systemName: "bookmark")!,
            for: .normal)
        cookTimeLabel.setTitle(data.cookTime, for: .normal)
    }
    
    func setUI() {
        recipeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        recipeTitle.snp.makeConstraints {
            $0.top.equalTo(recipeImageView.snp.top).offset(10)
            $0.left.equalTo(recipeImageView.snp.right).offset(15)
            $0.width.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(5)
            $0.left.equalTo(recipeImageView.snp.right).offset(15)
            $0.width.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(recipeTitle)
            $0.right.equalToSuperview().inset(30)
            $0.width.equalTo(14)
            $0.height.equalTo(17.82)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).inset(10)
            $0.right.equalTo(favoriteButton)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#if DEBUG
import SwiftUI
struct ForRecipeCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForRecipeCellPreview: PreviewProvider {
    static var previews: some View {
        ForRecipeCell()
            .previewLayout(.fixed(width: 380, height: 80))
    }
}
#endif
