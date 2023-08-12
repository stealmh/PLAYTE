//
//  MyPageHeaderView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct MyInfo: Hashable {
    let id = UUID()
    let nickName: String
    let email: String
    let loginType: String
}

final class MyPageHeaderView: UICollectionViewCell {
    
    /// UI Properties
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 22)
        v.textColor = .mainColor
        return v
    }()
    
    private let nickNameGuideLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 22)
        v.text = "님 맛있는 식사 하세요!"
        v.textColor = .black
        return v
    }()
    
    private let loginTypeImageView = UIImageView()
    
    private let emailLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        return v
    }()
    
    private let buttonActionBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .grayScale1
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    private let favoriteRecipeBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let writeRecipeBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let myReviewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let favoriteRecipeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "favoriteRecipe_svg"), for: .normal)
        return v
    }()
    
    private let writeRecipeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "writeRecipe_svg"), for: .normal)
        return v
    }()
    
    private let myReviewRecipeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "myReview_svg"), for: .normal)
        return v
    }()
    
    private let favoriteLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .grayScale6
        v.text = "저장 레시피"
        return v
    }()
    
    private let writeRecipeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .grayScale6
        v.text = "작성 레시피"
        return v
    }()
    
    private let myReviewLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .grayScale6
        v.text = "내가 쓴 리뷰"
        return v
    }()
    
    /// Properties
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        mockConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteRecipeBackground.layer.cornerRadius = favoriteRecipeBackground.frame.width / 2
        writeRecipeBackground.layer.cornerRadius = writeRecipeBackground.frame.width / 2
        myReviewBackground.layer.cornerRadius = myReviewBackground.frame.width / 2
    }
}

//MARK: - Method(Normal)
extension MyPageHeaderView {

    private func addView() {
        favoriteRecipeBackground.addSubview(favoriteRecipeButton)
        writeRecipeBackground.addSubview(writeRecipeButton)
        myReviewBackground.addSubview(myReviewRecipeButton)
        buttonActionBackground.addSubview(favoriteRecipeBackground)
        buttonActionBackground.addSubview(writeRecipeBackground)
        buttonActionBackground.addSubview(myReviewBackground)
        
        buttonActionBackground.addSubViews(favoriteLabel, writeRecipeLabel, myReviewLabel)
        
        addSubViews(nickNameLabel,
                    nickNameGuideLabel,
                    loginTypeImageView,
                    emailLabel,
                    buttonActionBackground)
    }
    
    private func configureLayout() {
        nickNameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(25)
            $0.height.equalTo(26)
            $0.width.greaterThanOrEqualTo(40)
        }
        
        nickNameGuideLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.left.equalTo(nickNameLabel.snp.rightMargin).offset(10)
        }
        
        loginTypeImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.left.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(loginTypeImageView)
            $0.left.equalTo(loginTypeImageView.snp.right).offset(10)
        }
        
        buttonActionBackground.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(30)
            $0.width.equalToSuperview()
            $0.height.equalTo(162)
        }
        
        writeRecipeBackground.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalTo(buttonActionBackground).offset(-10)
            $0.centerX.equalToSuperview()
        }
    
        writeRecipeButton.snp.makeConstraints {
            $0.center.equalTo(writeRecipeBackground)
        }
        
        favoriteRecipeBackground.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalTo(writeRecipeBackground)
            $0.right.equalTo(writeRecipeBackground.snp.left).offset(-40)
        }
    
        favoriteRecipeButton.snp.makeConstraints {
            $0.center.equalTo(favoriteRecipeBackground)
        }
        
        myReviewBackground.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalTo(writeRecipeBackground)
            $0.left.equalTo(writeRecipeBackground.snp.right).offset(40)
        }
    
        myReviewRecipeButton.snp.makeConstraints {
            $0.center.equalTo(myReviewBackground)
        }
        
        favoriteLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteRecipeBackground.snp.bottom).offset(10)
            $0.centerX.equalTo(favoriteRecipeBackground)
        }
        
        writeRecipeLabel.snp.makeConstraints {
            $0.top.equalTo(writeRecipeBackground.snp.bottom).offset(10)
            $0.centerX.equalTo(writeRecipeBackground)
        }
        
        myReviewLabel.snp.makeConstraints {
            $0.top.equalTo(myReviewBackground.snp.bottom).offset(10)
            $0.centerX.equalTo(myReviewBackground)
        }
    }
    
    private func mockConfigure() {
        nickNameLabel.text = "냉파CMC"
        loginTypeImageView.image = UIImage(named: "loginType_apple_svg")
        emailLabel.text = "kmh922@naver.com"
    }
    
    //for data inject
    func configure(_ item: MyInfo) {
        nickNameLabel.text = item.nickName
        emailLabel.text = item.email
        loginTypeImageView.image = item.loginType == "apple" ? UIImage(named: "loginType_apple_svg") : UIImage(named: "loginType_apple_svg")
    }
}


#if DEBUG
import SwiftUI
struct ForMyPageHeaderView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MyPageHeaderView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForMyPageHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        ForMyPageHeaderView()
            .previewLayout(.fixed(width: 327, height: 241))
//            .ignoresSafeArea()
    }
}
#endif


