//
//  RecipeDetailInfoCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol RecipeDetailInfoDelegate {
    func showReview()
    func favoriteButtonTapped(_ recipeId: Int)
}

final class RecipeDetailInfoCell: UICollectionViewCell {
    
    private let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "recipeDetail")
        v.layer.cornerRadius = 20
//        v.backgroundColor = .white
//        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.clipsToBounds = true
//
//        v.layer.masksToBounds = false
//        v.layer.shadowRadius = 2
//        v.layer.shadowOpacity = 0.1
//        v.layer.shadowOffset = CGSize(width: 0 , height:3)
        return v
    }()
    
    private let cellBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.layer.shadowColor = UIColor.black.cgColor
        v.clipsToBounds = true
        v.layer.masksToBounds = false
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0 , height:3)
        return v
    }()
    
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
        v.numberOfLines = 2
        return v
    }()
    
    let favoriteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "bookmark_svg"), for: .normal)
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
        v.image = UIImage(named: "recipeDetail_star_svg")
        return v
    }()
    
    private let personImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(named: "person_svg")
        return v
    }()
    
    private let timeImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(named: "recipeDetail_time_svg")
        return v
    }()
    
    let reviewButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "chevron.right"), for: .normal)// 이미지 넣기
        v.setTitleColor(.mainColor, for: .normal)
        v.tintColor = .mainColor
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
        v.textColor = .mainColor
        return v
    }()
    
    private let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .mainColor
        return v
    }()
    
    /// Properties
    private let disposeBag = DisposeBag()
    var delegate: RecipeDetailInfoDelegate?
    var recipeID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        bind()
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
        addSubview(backgroundImage)
addSubViews(cellBackground,nickNameLabel,uploadDateLabel,titleLabel,favoriteButton,contentsLabel,lineBackground,reviewImage,personImage,timeImage,personLabel,timeLabel,reviewButton)
    }
    
    private func configureLayout() {
        
        backgroundImage.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
        cellBackground.backgroundColor = .white
        cellBackground.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(240)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(cellBackground).inset(20)
            $0.left.equalTo(cellBackground).inset(35)
            $0.width.equalTo(140)
            $0.height.equalTo(14)
        }
        
        uploadDateLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.right.equalTo(cellBackground).inset(35)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.height.lessThanOrEqualTo(44)
            $0.width.equalToSuperview().dividedBy(1.7)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.right.equalTo(uploadDateLabel)
            $0.centerY.equalTo(titleLabel)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(38)
            $0.width.equalTo(198)
        }
        
        lineBackground.snp.makeConstraints {
            $0.left.equalTo(contentsLabel).offset(-3)
            $0.height.equalTo(0.5)
            $0.top.equalTo(contentsLabel.snp.bottom).offset(10)
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
            $0.left.right.equalTo(reviewImage)
//            $0.centerX.equalTo(reviewImage)
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
        titleLabel.text = "내가 만든 극강의 JMT 간장 계란밥"
        contentsLabel.text = "안 먹어본 사람은 있지만, 한 번 먹어본 사람은 없는 궁극의 초간단 간장 계란밥 레시피!"
        reviewButton.setTitle("3.6", for: .normal)
        personLabel.text = "2인분"
        timeLabel.text = "10분"
    } //for data inject
    
    func configure(_ item: Detail) {
        recipeID = item.recipe_id
        DispatchQueue.main.async {
            self.nickNameLabel.text = item.writtenby
            self.titleLabel.text = item.recipe_name
            self.contentsLabel.text = item.recipe_description
            self.reviewButton.setTitle("\(item.rating)", for: .normal)
            self.personLabel.text = "\(item.serving_size)인분"
            self.timeLabel.text = "\(item.cook_time)분"
            self.backgroundImage.loadImage(from: item.recipe_thumbnail_img)
            self.favoriteButton.setImage(UIImage(named: item.is_saved ? "bookmarkfill_svg" : "bookmark_svg")!,for: .normal)
            let dateString = item.created_date
            if let formattedDate = dateString.toDateFormatted() {
                self.uploadDateLabel.text = formattedDate
            } else {
                self.uploadDateLabel.text = dateString
            }
        }
    }
}

//MARK: - Method(Rx bind)
extension RecipeDetailInfoCell {
    private func bind() {
        reviewButton.rx.tap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("tapped")
                self.delegate?.showReview()
            }
        ).disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .subscribe(onNext: { _ in
                if let id = self.recipeID {
                    Task {
                        let data: DefaultOnlyCodeMessage = try await NetworkManager.shared.get(.recipeSave("\(id)"))
                        if data.code == "SUCCESS" {
                            DispatchQueue.main.async {
                                self.favoriteButton.setImage(UIImage(named: "bookmarkfill_svg"), for: .normal)
                            }
                        } else if data.code == "4005" {
                            let data: DefaultOnlyCodeMessage = try await NetworkManager.shared.get(.recipeUnSave("\(id)"))
                            if data.code == "SUCCESS" {
                                DispatchQueue.main.async {
                                    self.favoriteButton.setImage(UIImage(named: "bookmark_svg"), for: .normal)
                                }
                            }
                        }
                    }
                    
                    
//                    self.delegate?.favoriteButtonTapped(id)
                }
            }).disposed(by: disposeBag)
    }
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
