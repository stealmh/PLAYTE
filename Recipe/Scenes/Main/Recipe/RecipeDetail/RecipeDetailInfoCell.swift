//
//  RecipeDetailInfoCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import SnapKit

final class RecipeDetailInfoCell: UICollectionViewCell {
    
    /// UI Properties
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.textColor = .gray.withAlphaComponent(0.4)
        v.font = .systemFont(ofSize: 12)
        return v
    }()
    
    private let uploadDateLabel: UILabel = {
        let v = UILabel()
        v.textColor = .gray.withAlphaComponent(0.4)
        v.font = .systemFont(ofSize: 12)
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 18)
        return v
    }()
    
    private let favoriteButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "bookmark.fill", size: 23)
        v.setImage(img, for: .normal)
        v.tintColor = .mainColor
        return v
    }()
    
    private let contentsLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.numberOfLines = 10
        return v
    }()
    
    private let lineBackground: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lineColor?.cgColor
        return v
    }()
    
    private let reviewImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(named: "recipeDetail_reviewStar")
        return v
    }()
    
    private let personImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(named: "recipeDetail_person")
        return v
    }()
    
    private let timeImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(named: "recipeDetail_time")
        return v
    }()
    
    private let reviewButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "chevron.right"), for: .normal)// 이미지 넣기
        v.setTitleColor(.black, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceRightToLeft //<- 중v
        v.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let personLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    /// Properties
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        backgroundConfigure()
        addView()
        configureLayout()
        mockConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeDetailInfoCell {
    
    private func backgroundConfigure() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0 , height:3)
    }
    
    private func addView() {
        addSubViews(nickNameLabel,uploadDateLabel,titleLabel,favoriteButton,contentsLabel,lineBackground,reviewImage,personImage,timeImage,reviewButton,personLabel,timeLabel)
    }
    
    private func configureLayout() {
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(35)
            $0.width.equalTo(140)
            $0.height.equalTo(14)
        }
        
        uploadDateLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(35)
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(20)
            $0.height.equalTo(18)
            $0.width.equalToSuperview().dividedBy(1.7)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.right.equalTo(uploadDateLabel)
            $0.centerY.equalTo(titleLabel)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.height.equalTo(38)
            $0.width.equalTo(198)
        }
        
        lineBackground.snp.makeConstraints {
            $0.left.equalTo(contentsLabel).offset(-3)
            $0.height.equalTo(0.5)
            $0.top.equalTo(contentsLabel.snp.bottom).offset(20)
            $0.right.equalTo(favoriteButton.snp.right).offset(3)
        }
        
        reviewImage.snp.makeConstraints {
            $0.top.equalTo(lineBackground).offset(15)
            $0.left.equalTo(lineBackground).offset(15)
            $0.width.height.equalTo(37)
        }
        
        personImage.snp.makeConstraints {
            $0.top.width.height.equalTo(reviewImage)
            $0.centerX.equalTo(lineBackground)
        }
        
        timeImage.snp.makeConstraints {
            $0.top.width.height.equalTo(reviewImage)
            $0.right.equalTo(lineBackground).inset(15)
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(reviewImage.snp.bottom).offset(10)
            $0.centerX.equalTo(reviewImage)
        }
        
        personLabel.snp.makeConstraints {
            $0.top.equalTo(personImage.snp.bottom).offset(10)
            $0.centerX.equalTo(personImage)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(timeImage.snp.bottom).offset(10)
            $0.centerX.equalTo(timeImage)
        }
        
    }
    private func mockConfigure() {
        nickNameLabel.text = "규땡뿡야"
        uploadDateLabel.text = "2023.02.12"
        titleLabel.text = "토마토 계란 볶음밥"
        contentsLabel.text = "토마토가 많아서 볶아먹고 삶아먹고 \n이젠 밥에도 넣어봤어요"
        reviewButton.setTitle("4.38", for: .normal)
        personLabel.text = "2인분"
        timeLabel.text = "10분"
    } //for data inject
    
    func configure() {}
}

//MARK: - Method(Rx bind)
extension RecipeDetailInfoCell {
    private func bind() {}
}

#if DEBUG
import SwiftUI
struct ForRecipeDetailInfoCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailInfoCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForRecipeDetailInfoCell_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailInfoCell()
//            .previewLayout(.fixed(width: 327, height: 241))
            .ignoresSafeArea()
    }
}
#endif
