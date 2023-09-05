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

protocol RecipeDetailReviewHeaderDelegate {
    func didTappedMorePhotoButton(_ item: [String])
}

final class RecipeDetailReviewHeader: UICollectionViewCell {
    
    /// UI Properties
    private let scoreTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 36)
        v.textAlignment = .center
        v.text = "0.0"
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
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star2: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star3: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star4: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let star5: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
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
        v.isHidden = true
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
        v.isHidden = true
        return v
    }()
    
    private let fiveRatingBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let fiveRatingBackgroundFill: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let threeRatingBackgroundFill: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let twoRatingBackgroundFill: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let oneRatingBackgroundFill: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
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
    
    private let fourRatingBackgroundFill: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
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
    var delegate: RecipeDetailReviewHeaderDelegate?
    lazy var starImages = [star1, star2, star3, star4 ,star5]
    var myrating: Double = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        backgroundConfigure()
        addView()
        bind()
        configureLayout()
        configure()
//        mockConfigure()
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
        addSubViews(fiveRatingBackgroundFill,
                    fourRatingBackgroundFill,
                    threeRatingBackgroundFill,
                    twoRatingBackgroundFill,
                    oneRatingBackgroundFill)
        addSubViews(fiveLabel, fourLabel, threeLabel, twoLabel, oneLabel)
    }
    
    private func configureLayout() {
        scoreTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.equalToSuperview().inset(40)
            $0.right.equalTo(lineDivideBackground.snp.right).inset(40)
            $0.height.equalTo(43)
        }
//        scoreTitle.backgroundColor = .blue
//        starStack.backgroundColor = .red
        starStack.snp.makeConstraints {
            $0.top.equalTo(scoreTitle.snp.bottom).offset(5)
            $0.left.right.equalTo(scoreTitle)
            $0.height.equalTo(20)
        }
        
        lineDivideBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
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
            $0.width.height.equalTo(75)
        }
        
        thumbnailSecondImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailFirstImageView.snp.right).offset(10)
            $0.width.height.equalTo(75)
        }
        
        thumbnailThirdImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailSecondImageView.snp.right).offset(10)
            $0.width.height.equalTo(75)
        }
        
        moreBackground.snp.makeConstraints {
            $0.top.equalTo(thumbnailFirstImageView)
            $0.left.equalTo(thumbnailThirdImageView.snp.right).offset(10)
            $0.height.equalTo(75)
            $0.right.equalToSuperview().inset(20)
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
        self.myrating = 4.7
        thumbnailFirstImageView.image = UIImage(named: "popcat")
        thumbnailSecondImageView.image = UIImage(named: "popcat")
        thumbnailThirdImageView.image = UIImage(named: "popcat")
        moreTitle.text = "57개"
        
        for i in 0..<5 {
            if myrating >= 1 {
                myrating -= 1
                starImages[i].image = UIImage(named: "star_fill_svg")
            }
            else {
                starImages[i].image = UIImage(named: "star_empty_svg")
            }
        }
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
    
    func configure(_ item: StarPoint) {
        DispatchQueue.main.async {
            self.scoreTitle.text = "\(item.totalRating)"
        }
        self.myrating = item.totalRating
        var totalReviewCount: Double = 0.0
        totalReviewCount += Double(item.fivePoint)
        totalReviewCount += Double(item.fourPoint)
        totalReviewCount += Double(item.threePoint)
        totalReviewCount += Double(item.twoPoint)
        totalReviewCount += Double(item.onePoint)
        
        let ratings = [
            (point: 1, value: item.onePoint),
            (point: 2, value: item.twoPoint),
            (point: 3, value: item.threePoint),
            (point: 4, value: item.fourPoint),
            (point: 5, value: item.fivePoint)
        ]

        let maxRatingValue = ratings.max(by: { $0.value < $1.value })?.value
        let maxRatings = ratings.filter { $0.value == maxRatingValue }
        let highestPointWithMaxRating = maxRatings.max(by: { $0.point < $1.point })?.point

        DispatchQueue.main.async {
            switch highestPointWithMaxRating {
            case 1:
                self.oneLabel.textColor = .mainColor
            case 2:
                self.twoLabel.textColor = .mainColor
            case 3:
                self.threeLabel.textColor = .mainColor
            case 4:
                self.fourLabel.textColor = .mainColor
            case 5:
                self.fiveLabel.textColor = .mainColor
            default:
                break
            }

            // [기존의 레이아웃 코드를 그대로 유지합니다]
        }
        
        for i in 0..<5 {
            print(self.myrating)
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
        
        DispatchQueue.main.async {
            self.oneRatingBackgroundFill.snp.makeConstraints {
                $0.bottom.width.equalTo(self.oneRatingBackground)
                $0.left.equalTo(self.oneRatingBackground)
                if Double(item.onePoint) > 0 {
                    $0.height.equalTo(self.oneRatingBackground).multipliedBy((Double(item.onePoint) / totalReviewCount))
                } else {
                    $0.height.equalTo(0)
                }
            }
            
            self.twoRatingBackgroundFill.snp.makeConstraints {
                $0.bottom.width.equalTo(self.twoRatingBackground)
                $0.left.equalTo(self.twoRatingBackground)
                if Double(item.twoPoint) > 0 {
                    $0.height.equalTo(self.twoRatingBackground).multipliedBy((Double(item.twoPoint) / totalReviewCount))
                } else {
                    $0.height.equalTo(0)
                }
            }
            
            self.threeRatingBackgroundFill.snp.makeConstraints {
                $0.bottom.width.equalTo(self.threeRatingBackground)
                $0.left.equalTo(self.threeRatingBackground)
                if Double(item.threePoint) > 0 {
                    $0.height.equalTo(self.threeRatingBackground).multipliedBy((Double(item.threePoint) / totalReviewCount))
                } else {
                    $0.height.equalTo(0)
                }

            }
            
            self.fourRatingBackgroundFill.snp.makeConstraints {
                $0.bottom.width.equalTo(self.fourRatingBackground)
                $0.left.equalTo(self.fourRatingBackground)
                if Double(item.fourPoint) > 0 {
                    $0.height.equalTo(self.fourRatingBackground).multipliedBy((Double(item.fourPoint) / totalReviewCount))
                } else {
                    $0.height.equalTo(0)
                }

            }
            
            self.fiveRatingBackgroundFill.snp.makeConstraints {
                $0.bottom.width.equalTo(self.fiveRatingBackground)
                $0.left.equalTo(self.fiveRatingBackground)
                if Double(item.fivePoint) > 0 {
                    $0.height.equalTo(self.fiveRatingBackground).multipliedBy((Double(item.fivePoint) / totalReviewCount))
                } else {
                    $0.height.equalTo(0)
                }

            }
        }
    }
    
    func configurePhoto(_ item: ReviewPhoto) {
        
        moreButton.rx.tap
            .subscribe(onNext: { _ in
                print("moreButton Tappd - RecipeDetailReviewHeader")
                self.delegate?.didTappedMorePhotoButton(item.data)
            }
        ).disposed(by: disposeBag)
        
        switch item.data.count {
        case 0:
            DispatchQueue.main.async {
                self.thumbnailFirstImageView.isHidden = true
                self.thumbnailSecondImageView.isHidden = true
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            }
        case 1:
            DispatchQueue.main.async {
                self.thumbnailFirstImageView.backgroundColor = .grayScale3
                self.thumbnailFirstImageView.loadImage(from: item.data[0])
                self.thumbnailSecondImageView.isHidden = true
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            }
        case 2:
            DispatchQueue.main.async {
                self.thumbnailFirstImageView.backgroundColor = .grayScale3
                self.thumbnailSecondImageView.backgroundColor = .grayScale3
                self.thumbnailFirstImageView.loadImage(from: item.data[0])
                self.thumbnailSecondImageView.loadImage(from: item.data[1])
                self.thumbnailThirdImageView.isHidden = true
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            }
        case 3:
            DispatchQueue.main.async {
                self.thumbnailFirstImageView.backgroundColor = .grayScale3
                self.thumbnailSecondImageView.backgroundColor = .grayScale3
                self.thumbnailThirdImageView.backgroundColor = .grayScale3
                self.thumbnailFirstImageView.loadImage(from: item.data[0])
                self.thumbnailSecondImageView.loadImage(from: item.data[1])
                self.thumbnailThirdImageView.loadImage(from: item.data[2])
                self.moreBackground.isHidden = true
                self.moreButton.isHidden = true
            }
        default:
            DispatchQueue.main.async {
                self.thumbnailFirstImageView.backgroundColor = .grayScale3
                self.thumbnailSecondImageView.backgroundColor = .grayScale3
                self.thumbnailThirdImageView.backgroundColor = .grayScale3
                self.moreBackground.backgroundColor = .grayScale3
                self.thumbnailFirstImageView.loadImage(from: item.data[0])
                self.thumbnailSecondImageView.loadImage(from: item.data[1])
                self.thumbnailThirdImageView.loadImage(from: item.data[2])
                self.moreBackground.loadImage(from: item.data[3])
                self.moreTitle.text = "\(item.data.count)개"
                self.moreBackground.isHidden = false
                self.moreButton.isHidden = false
            }
        }
    }
}

//MARK: - Method(Rx bind)
extension RecipeDetailReviewHeader {
    private func bind() {
        
//        moreButton.rx.tap
//            .subscribe(onNext: { _ in
//                print("moreButton Tappd - RecipeDetailReviewHeader")
//                self.delegate?.didTappedMorePhotoButton(<#[String]#>)
//            }
//        ).disposed(by: disposeBag)
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
