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

protocol ReviewCellPhotoDelegate: AnyObject {
    func reviewPhotoSend(_ item: [String])
    func likeButtonTapped()
    func singoButtonTapped()
}

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
        v.numberOfLines = 0
        return v
    }()
    
    let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "heart_review_svg"), for: .normal)// 이미지 넣기
        v.setTitleColor(.grayScale3, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight //<- 중v
        v.imageEdgeInsets = .init(top: 2, left: -5, bottom: 0, right: 0) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let singoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "ban_empty_svg"), for: .normal)// 이미지 넣기
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight //<- 중v
        v.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 15) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let starStack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 0
        return v
    }()
    private let star1: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let star2: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let star3: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let star4: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let star5: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let thumbnailFirstImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        v.backgroundColor = .grayScale3
        return v
    }()
    
    private let thumbnailSecondImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        v.backgroundColor = .grayScale3
        return v
    }()
    
    private let thumbnailThirdImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.backgroundColor = .grayScale3
        v.clipsToBounds = true
        return v
    }()
    
    private let moreBackground: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 6.13
        v.clipsToBounds = true
        v.backgroundColor = .grayScale3
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
    let disposeBag = DisposeBag()
    var delegate: RecipeDetailInfoDelegate?
    var photoDelegate: ReviewCellPhotoDelegate?
    lazy var starImages = [star1, star2, star3, star4 ,star5]
    var imgURL: [String] = []
    var myrating: Double = 0.0
    var likeCheck = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        moreBackground.addoverlay()
        
        moreButton.rx.tap
            .subscribe(onNext: { _ in
                print("moreButton Tapped")
                self.photoDelegate?.reviewPhotoSend(self.imgURL)
            }).disposed(by: disposeBag)
        
        
        for i in 0..<5 {
            if myrating >= 1 {
                myrating -= 1
                DispatchQueue.main.async {
                    self.starImages[i].image = UIImage(named: "star_fill_svg")
                }
            }
            else {
                DispatchQueue.main.async {
                    self.starImages[i].image = UIImage(named: "star_empty_svg")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailFirstImageView.isHidden = true
        self.thumbnailSecondImageView.isHidden = true
        self.thumbnailThirdImageView.isHidden = true
        self.moreBackground.isHidden = true
        
        self.thumbnailFirstImageView.image = nil
        self.thumbnailSecondImageView.image = nil
        self.thumbnailThirdImageView.image = nil
        self.moreBackground.image = nil
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
        addSubViews(starStack, nickNameLabel, dateLabel, reviewTitleLabel, reviewContentsLabel, thumbnailFirstImageView, thumbnailSecondImageView, thumbnailThirdImageView, moreBackground, moreTitle, divideLine)
        contentView.addSubViews(moreButton, likeButton, singoButton)
    }
    
    private func configureLayout() {
//        nickNameLabel.backgroundColor = .blue
        nickNameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(20)
//            $0.height.equalTo(14)
            $0.height.greaterThanOrEqualTo(14)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
//        reviewTitleLabel.backgroundColor = .blue
        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom)
            $0.left.equalTo(nickNameLabel)
            $0.height.equalTo(25)
//            $0.height.greaterThanOrEqualTo(16)
        }
//        reviewContentsLabel.backgroundColor = .red
        reviewContentsLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTitleLabel.snp.bottom)
//            $0.bottom.equalTo(thumbnailFirstImageView.snp.top).offset(-10)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(10)
            $0.height.greaterThanOrEqualTo(50)
//            $0.height.greaterThanOrEqualTo(1)
        }

//        likeButton.backgroundColor = .red
        likeButton.snp.makeConstraints {
            $0.left.equalTo(dateLabel).inset(5)
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.width.equalTo(dateLabel).dividedBy(2)
            $0.height.equalTo(dateLabel)
        }

//        singoButton.backgroundColor = .red
        singoButton.snp.makeConstraints {
            $0.top.equalTo(likeButton)
//            $0.right.equalTo(dateLabel)
            $0.right.equalToSuperview().inset(0)
            $0.width.equalTo(likeButton)
            $0.height.equalTo(dateLabel)
        }
//        starStack.backgroundColor = .red
        starStack.snp.makeConstraints {
            $0.top.bottom.equalTo(nickNameLabel)
            $0.left.equalTo(nickNameLabel.snp.right).offset(10)
//            $0.height.equalTo(15)
            $0.width.equalTo(80)
            $0.height.equalTo(20)
        }
        
        thumbnailFirstImageView.snp.makeConstraints {
            $0.top.equalTo(reviewContentsLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.lessThanOrEqualTo(80)
//            $0.bottom.equalTo(divideLine).inset(10)
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
            $0.top.equalTo(reviewContentsLabel.snp.bottom).offset(10)
            $0.left.equalTo(thumbnailThirdImageView.snp.right).offset(10)
            $0.height.lessThanOrEqualTo(79)
            $0.right.equalToSuperview().inset(10)
//            $0.bottom.equalTo(divideLine).inset(10)
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
            $0.top.equalTo(thumbnailFirstImageView.snp.bottom).offset(15)
            $0.left.equalTo(thumbnailFirstImageView)
            $0.right.equalTo(moreBackground)
//            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(_ item: ReviewInfo) {
        print(#function)
        print(item)
        self.myrating = item.rating
        self.likeCheck = item.liked
        let dateString = item.modified_at
        if let formattedDate = dateString.toDateFormatted() {
            DispatchQueue.main.async {
                self.dateLabel.text = formattedDate
            }
        } else {
            DispatchQueue.main.async {
                self.dateLabel.text = dateString
            }
        }
        DispatchQueue.main.async {
            
            self.nickNameLabel.text = item.writtenby
            self.reviewTitleLabel.text = item.review_title
            self.reviewContentsLabel.text = item.review_content
            
            print("imageCount::", item.review_images.count)
            switch item.review_images.count {
            case 0:
                self.thumbnailFirstImageView.isHidden = true
                self.thumbnailSecondImageView.isHidden = true
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            case 1:
                self.thumbnailFirstImageView.loadImage(from: item.review_images[0])
                self.thumbnailSecondImageView.isHidden = true
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            case 2:
                self.thumbnailFirstImageView.loadImage(from: item.review_images[0])
                self.thumbnailSecondImageView.loadImage(from: item.review_images[1])
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            case 3:
                self.thumbnailFirstImageView.loadImage(from: item.review_images[0])
                self.thumbnailSecondImageView.loadImage(from: item.review_images[1])
                self.thumbnailThirdImageView.loadImage(from: item.review_images[2])
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            default:
                self.imgURL = item.review_images
                self.thumbnailFirstImageView.loadImage(from: item.review_images[0])
                self.thumbnailSecondImageView.loadImage(from: item.review_images[1])
                self.thumbnailThirdImageView.loadImage(from: item.review_images[2])
                self.moreBackground.loadImage(from: item.review_images[3])
            }


            self.moreTitle.text = "\(item.review_images.count)개"
            self.likeButton.setTitle("\(item.like_count)", for: .normal)
            
            if item.liked {
                self.likeButton.setImage(UIImage(named: "heart_review_fill_svg"), for: .normal)
                self.likeButton.setTitleColor(.mainColor, for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart_review_svg"), for: .normal)
                self.likeButton.setTitleColor(.grayScale3, for: .normal)
            }
        }
        
        for i in 0..<5 {
            if myrating >= 1 {
                myrating -= 1
                DispatchQueue.main.async {
                    self.starImages[i].image = UIImage(named: "star_fill_svg")
                }
            }
            else {
                DispatchQueue.main.async {
                    self.starImages[i].image = UIImage(named: "star_empty_svg")
                }
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
