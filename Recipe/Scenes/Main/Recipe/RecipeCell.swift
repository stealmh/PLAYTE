//
//  RecipeCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import SnapKit

final class RecipeCell: UICollectionViewCell {
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    private let recipeTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        v.textColor = .black
        
        return v
    }()
    
    private let favoriteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "bookmarkfill_svg"), for: .normal)
        return v
    }()
    private let tagLabel = UILabel()
    private let cookTimeLabel: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "time_svg"), for: .normal)
        v.setTitleColor(.grayScale4, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .left
        return v
    }()
    
    private let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .grayScale4
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    private let divideLine: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.grayScale4?.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    private let nickName: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        return v
    }()
    private let rate: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "star_svg"), for: .normal)
        v.setTitleColor(.mainColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .left
        return v
    }()
    
    private let circleBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 10
        v.layer.cornerRadius = 20
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews(recipeImageView,
                    recipeTitle,
                    tagLabel,favoriteButton,cookTimeLabel, uploadTimeLabel, divideLine, nickName, rate, circleBackground)
        
        self.configureLayout()
        mockData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeCell {
    
    func configureLayout() {
        recipeImageView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        uploadTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(recipeImageView.snp.right).offset(20)
            $0.height.equalTo(17)
            $0.width.greaterThanOrEqualTo(35)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.height.equalTo(uploadTimeLabel)
            $0.left.equalTo(uploadTimeLabel.snp.right).offset(10)
            $0.width.equalTo(1)
        }

        nickName.snp.makeConstraints {
            $0.top.height.equalTo(uploadTimeLabel)
            $0.left.equalTo(divideLine.snp.right).offset(10)
            $0.width.equalTo(150)
        }

        recipeTitle.snp.makeConstraints {
            $0.top.equalTo(uploadTimeLabel.snp.bottom).offset(10)
            $0.left.equalTo(uploadTimeLabel)
            $0.width.equalTo(200)
            $0.height.equalTo(19)
        }

        rate.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(10)
            $0.left.equalTo(uploadTimeLabel)
            $0.height.equalTo(20)
            $0.width.greaterThanOrEqualTo(74)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.height.width.equalTo(rate)
            $0.left.equalTo(rate.snp.right).offset(10)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(recipeTitle)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
    }
    
    func mockData() {
        recipeImageView.image = UIImage(named: "popcat")
        recipeTitle.text = "토마토 계란 볶음밥"
        tagLabel.text = "??"
        cookTimeLabel.setTitle("10분", for: .normal)
        uploadTimeLabel.text = "31분전"
        rate.setTitle("4.7(104)", for: .normal)
        nickName.text = "규땡뿡야"
    }
    
    func configure(_ data: RecipeInfo) {
        let timeString = data.created_date
        if let result = timeString.timeAgo() {
            uploadTimeLabel.text = result
        }
        
        recipeImageView.loadImage(from: data.recipe_thumbnail_img)
        rate.setTitle("\(data.rating)(\(data.comment_count))", for: .normal)
        nickName.text = data.nickname
        recipeTitle.text = data.recipe_name
        favoriteButton.setImage(
            data.is_saved ? UIImage(named: "bookmarkfill_svg")! : UIImage(named: "bookmark_svg")!,
            for: .normal)
        cookTimeLabel.setTitle("10분", for: .normal)
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
            .previewLayout(.fixed(width: 380, height: 100))
    }
}
#endif
