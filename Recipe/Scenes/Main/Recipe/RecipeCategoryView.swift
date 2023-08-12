//
//  RecipeCategoryView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit
import SnapKit

final class RecipeCategoryView: UIView {
    
    private let homeAloneView = DefaultRecipeCategoryView(text: "자취생 필수!", color: .mainColor ?? .white, img: UIImage(named: "homealone_svg")!)
    private let dietView = DefaultRecipeCategoryView(text: "다이어터를\n위한 레시피", color: .sub3 ?? .white, img: UIImage(named: "diet_svg")!)
    private let manwonView = DefaultRecipeCategoryView(text: "알뜰살뜰\n만원의 행복", color: .sub2 ?? .white, img: UIImage(named: "manwon_svg")!)
    private let homePartyView = DefaultRecipeCategoryView(text: "집들이용\n레시피", color: .sub4 ?? .white, img: UIImage(named: "homeparty_svg")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews(homeAloneView, dietView, manwonView, homePartyView)
        configureLayout()
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeCategoryView {
    func configureLayout() {
        homeAloneView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.height.equalTo(80)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        dietView.snp.makeConstraints {
            $0.top.height.width.equalTo(homeAloneView)
            $0.left.equalTo(homeAloneView.snp.right)
        }
        
        manwonView.snp.makeConstraints {
            $0.top.equalTo(homeAloneView.snp.bottom)
            $0.left.height.width.equalTo(homeAloneView)
        }
        
        homePartyView.snp.makeConstraints {
            $0.width.height.equalTo(homeAloneView)
            $0.top.equalTo(dietView.snp.bottom)
            $0.left.equalTo(dietView)
        }
        
    }
}

#if DEBUG
import SwiftUI
struct ForRecipeCategoryView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeCategoryView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForRecipeCategoryView_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeCategoryView()
//            .previewLayout(.fixed(width: 200, height: 81))
    }
}
#endif
