//
//  ReviewCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class ReviewCell: UICollectionViewCell {
    
    /// UI Properties
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .gray
        return v
    }()
    
    private let dateLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .gray
        return v
    }()
    
    private let reviewTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        return v
    }()
    
    private let reviewContentsLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.numberOfLines = 4
        return v
    }()
    
    private let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "like"), for: .normal)// 이미지 넣기
        v.setTitleColor(.mainColor, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight //<- 중v
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let dislikeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "dislike"), for: .normal)// 이미지 넣기
        v.setTitleColor(.gray, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight //<- 중v
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let starStack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        return v
    }()
    private let star1: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "StarEmpty")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star2: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "StarEmpty")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star3: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "StarEmpty")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star4: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "StarEmpty")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star5: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "StarEmpty")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let thumbnailFirstImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        return v
    }()
    
    private let thumbnailSecondImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        return v
    }()
    
    private let thumbnailThirdImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        return v
    }()
    
    private let moreBackground: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    private let moreTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12.48)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    private let moreButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceRightToLeft
        v.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let divideLine: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.lineColor?.withAlphaComponent(0.4).cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    /// Properties
    private let disposeBag = DisposeBag()
    var delegate: RecipeDetailInfoDelegate?
    lazy var starImages = [star1, star2, star3, star4 ,star5]
    var testrating: Double = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        bind()
        configureLayout()
//        configure()
        mockConfigure()
        moreBackground.addoverlay()
//        contentView.autoresizingMask = .flexibleHeight
//        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension ReviewCell {
    
    private func addView() {
        starStack.addArrangedSubview(star1)
        starStack.addArrangedSubview(star2)
        starStack.addArrangedSubview(star3)
        starStack.addArrangedSubview(star4)
        starStack.addArrangedSubview(star5)
        addSubViews(starStack, nickNameLabel, dateLabel, reviewTitleLabel, reviewContentsLabel, thumbnailFirstImageView, thumbnailSecondImageView, thumbnailThirdImageView, moreBackground, moreTitle, moreButton, likeButton, dislikeButton, divideLine)
    }
    
    private func configureLayout() {
        nickNameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(20)
//            $0.height.equalTo(14)
            $0.height.greaterThanOrEqualTo(14)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel).inset(30)
            $0.left.equalTo(nickNameLabel)
//            $0.height.equalTo(16)
            $0.height.greaterThanOrEqualTo(16)
        }
        
        reviewContentsLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(15)
            $0.bottom.equalTo(thumbnailFirstImageView.snp.top).offset(-10)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalToSuperview()
//            $0.height.equalTo(34)
            $0.height.greaterThanOrEqualTo(1)
        }

        likeButton.snp.makeConstraints {
            $0.left.equalTo(dateLabel)
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.width.equalTo(dateLabel).dividedBy(2)
            $0.height.equalTo(dateLabel)
        }

        dislikeButton.snp.makeConstraints {
            $0.top.equalTo(likeButton)
            $0.right.equalTo(dateLabel)
            $0.width.equalTo(likeButton)
            $0.height.equalTo(dateLabel)
        }
        
        starStack.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel)
            $0.left.equalTo(nickNameLabel.snp.right).offset(10)
//            $0.height.equalTo(15)
            $0.height.greaterThanOrEqualTo(15)
        }
        
        thumbnailFirstImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
//            $0.width.height.equalTo(80)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.lessThanOrEqualTo(80)
            $0.bottom.equalTo(divideLine).inset(10)
        }
        
        thumbnailSecondImageView.snp.makeConstraints {
            $0.left.equalTo(thumbnailFirstImageView.snp.right).offset(10)
            $0.top.width.height.equalTo(thumbnailFirstImageView)
        }
        
        thumbnailThirdImageView.snp.makeConstraints {
            $0.left.equalTo(thumbnailSecondImageView.snp.right).offset(10)
            $0.top.width.height.equalTo(thumbnailFirstImageView)
        }
        
        moreBackground.snp.makeConstraints {
            $0.left.equalTo(thumbnailThirdImageView.snp.right).offset(10)
//            $0.height.equalTo(79)
            $0.height.lessThanOrEqualTo(79)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalTo(divideLine).inset(10)
        }
        moreTitle.snp.makeConstraints {
            $0.top.equalTo(moreBackground).offset(20)
            $0.left.right.equalTo(moreBackground)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(moreTitle.snp.bottom).offset(10)
            $0.centerX.equalTo(moreBackground)
        }
        divideLine.snp.makeConstraints {
            $0.left.equalTo(thumbnailFirstImageView)
            $0.right.equalTo(moreBackground)
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
        }
    }
    private func mockConfigure() {
        nickNameLabel.text = "냉파 CMC"
        dateLabel.text = "2023.05.11"
        reviewTitleLabel.text = "기름이 너무 많아서"
        reviewContentsLabel.text = "기름이 너무 많아서 망했습니다. 맛은 있는데 약간 짜고 느끼한 감이 좀 있어요. 그래도 다들 한번씩 해보길"
        self.testrating = 4.7
        thumbnailFirstImageView.image = UIImage(named: "popcat")
        thumbnailSecondImageView.image = UIImage(named: "popcat")
        thumbnailThirdImageView.image = UIImage(named: "popcat")
        moreTitle.text = "57개"
        likeButton.setTitle("9", for: .normal)
        dislikeButton.setTitle("3", for: .normal)
        bind()
    } //for data inject
    
    func configure(_ item: Review) {
        
        nickNameLabel.text = item.nickName
        dateLabel.text = item.date
        reviewTitleLabel.text = item.title
        reviewContentsLabel.text = item.contents
        self.testrating = item.rate
        thumbnailFirstImageView.image = UIImage(named: "popcat")
        thumbnailSecondImageView.image = UIImage(named: "popcat")
        thumbnailThirdImageView.image = UIImage(named: "popcat")
        moreTitle.text = "\(item.photos.count)개"
        likeButton.setTitle("\(item.like)", for: .normal)
        dislikeButton.setTitle("\(item.dislike)", for: .normal)
    }
}

//MARK: - Method(Rx bind)
extension ReviewCell {
    private func bind() {
        for i in 0..<5 {
            if testrating > 1 {
                testrating -= 1
                starImages[i].image = UIImage(named: "StarFill")
            }
            else {
                starImages[i].image = UIImage(named: "StarEmpty")
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct ForReviewCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ReviewCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ReviewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForReviewCell()
            .previewLayout(.fixed(width: 350, height: 231))

    }
}
#endif
