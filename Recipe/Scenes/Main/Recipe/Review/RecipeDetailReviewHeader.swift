//
//  RecipeDetailReviewHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class RecipeDetailReviewHeader: UICollectionViewCell {
    
    /// UI Properties
    private let scoreTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 36)
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
    
    private let lineDivideBackground: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lineColor?.cgColor
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
    
    private let fiveRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let fiveLabel = UILabel()
    private let fourLabel = UILabel()
    private let threeLabel = UILabel()
    private let twoLabel = UILabel()
    private let oneLabel = UILabel()
    
    private let fourRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let threeRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let twoRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let oneRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
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
        backgroundConfigure()
        addView()
        bind()
        configureLayout()
        configure()
        mockConfigure()
        moreBackground.addoverlay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeDetailReviewHeader {
    
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
        starStack.addArrangedSubview(star1)
        starStack.addArrangedSubview(star2)
        starStack.addArrangedSubview(star3)
        starStack.addArrangedSubview(star4)
        starStack.addArrangedSubview(star5)
        addSubViews(starStack, scoreTitle, lineDivideBackground, thumbnailFirstImageView, thumbnailSecondImageView, thumbnailThirdImageView, moreBackground, moreTitle, moreButton)
        
        addSubViews(fiveRatingBackground, fourRatingBackground, threeRatingBackground, twoRatingBackground, oneRatingBackground)
        
        addSubViews(fiveLabel, fourLabel, threeLabel, twoLabel, oneLabel)
    }
    
    private func configureLayout() {
        scoreTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(50)
            $0.height.equalTo(43)
        }
        
        starStack.snp.makeConstraints {
            $0.top.equalTo(scoreTitle.snp.bottom).offset(5)
            $0.left.right.equalTo(scoreTitle)
            $0.height.equalTo(15)
        }
        
        lineDivideBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(100)
        }
        
        fiveRatingBackground.snp.makeConstraints {
            $0.top.equalTo(lineDivideBackground).offset(5)
            $0.left.equalTo(lineDivideBackground).offset(30)
            $0.width.equalTo(10)
            $0.height.equalTo(80)
        }
        
        fiveLabel.snp.makeConstraints {
            $0.centerX.equalTo(fiveRatingBackground)
            $0.top.equalTo(fiveRatingBackground.snp.bottom).offset(10)
        }
        
        fourRatingBackground.snp.makeConstraints {
            $0.top.width.height.equalTo(fiveRatingBackground)
            $0.left.equalTo(fiveRatingBackground).offset(25)
        }
        
        fourLabel.snp.makeConstraints {
            $0.centerX.equalTo(fourRatingBackground)
            $0.top.equalTo(fourRatingBackground.snp.bottom).offset(10)
        }
        
        threeRatingBackground.snp.makeConstraints {
            $0.top.width.height.equalTo(fiveRatingBackground)
            $0.left.equalTo(fourRatingBackground).offset(25)
        }
        
        threeLabel.snp.makeConstraints {
            $0.centerX.equalTo(threeRatingBackground)
            $0.top.equalTo(threeRatingBackground.snp.bottom).offset(10)
        }
        
        twoRatingBackground.snp.makeConstraints {
            $0.top.width.height.equalTo(fiveRatingBackground)
            $0.left.equalTo(threeRatingBackground).offset(25)
        }
        
        twoLabel.snp.makeConstraints {
            $0.centerX.equalTo(twoRatingBackground)
            $0.top.equalTo(twoRatingBackground.snp.bottom).offset(10)
        }
        
        oneRatingBackground.snp.makeConstraints {
            $0.top.width.height.equalTo(fiveRatingBackground)
            $0.left.equalTo(twoRatingBackground).offset(25)
        }
        
        oneLabel.snp.makeConstraints {
            $0.centerX.equalTo(oneRatingBackground)
            $0.top.equalTo(oneRatingBackground.snp.bottom).offset(10)
        }
        
        thumbnailFirstImageView.snp.makeConstraints {
            $0.top.equalTo(fiveLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(80)
        }
        
        thumbnailSecondImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailFirstImageView.snp.right).offset(10)
            $0.width.height.equalTo(80)
        }
        
        thumbnailThirdImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailSecondImageView.snp.right).offset(10)
            $0.width.height.equalTo(80)
        }
        
        moreBackground.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailThirdImageView.snp.right).offset(10)
            $0.height.equalTo(79)
            $0.right.equalToSuperview().inset(10)
        }
        moreTitle.snp.makeConstraints {
            $0.top.equalTo(moreBackground).offset(20)
            $0.left.right.equalTo(moreBackground)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(moreTitle.snp.bottom).offset(10)
            $0.centerX.equalTo(moreBackground)
        }
    }
    private func mockConfigure() {
        scoreTitle.text = "4.70"
        self.testrating = 4.7
        thumbnailFirstImageView.image = UIImage(named: "popcat")
        thumbnailSecondImageView.image = UIImage(named: "popcat")
        thumbnailThirdImageView.image = UIImage(named: "popcat")
        moreTitle.text = "57개"
        bind()
    } //for data inject
    
    func configure() {
        let label = [oneLabel, twoLabel, threeLabel, fourLabel, fiveLabel]
        label.enumerated().forEach { idx, lbl in
            lbl.font = .systemFont(ofSize: 12)
            lbl.textColor = .gray.withAlphaComponent(0.4)
            lbl.text = "\(idx + 1)점"
        }
//        fiveLabel.text = "5점"
//        fourLabel.text = "4점"
//        threeLabel.text = "3점"
//        twoLabel.text = "2점"
//        oneLabel.text = "1점"
    }
}

//MARK: - Method(Rx bind)
extension RecipeDetailReviewHeader {
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
struct ForRecipeDetailReviewHeaderr: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailReviewHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeDetailReviewHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailReviewHeaderr()
            .previewLayout(.fixed(width: 350, height: 261))
            .ignoresSafeArea()
    }
}
#endif
