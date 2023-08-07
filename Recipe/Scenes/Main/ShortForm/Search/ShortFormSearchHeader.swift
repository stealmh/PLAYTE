//
//  ShortFormSearchHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShortFormSearchHeader: UICollectionReusableView {
    
    /// UI Properties
    // 최신, 인기, 최소 시간순
    private let recentBackground: RecipeDefaultTagView = {
        let v = RecipeDefaultTagView()
        v.backgroundColor = .mainColor
        return v
    }()
    private let popularBackground = RecipeDefaultTagView()
    private let minimumBackground = RecipeDefaultTagView()
    private let recentButton = RecipeDefaultTagButton(tagName: "최신순", tag: 0)
    private let popularButton = RecipeDefaultTagButton(tagName: "인기순", tag: 1)
    private let minimumButton = RecipeDefaultTagButton(tagName: "최소 시간순", tag: 2)
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        return v
    }()
    /// Properties
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        recentBackground.addSubview(recentButton)
        popularBackground.addSubview(popularButton)
        minimumBackground.addSubview(minimumButton)
        stackView.addArrangeViews(recentBackground, popularBackground, minimumBackground)
        addSubViews(stackView)
        configureLayout()
        recentButton.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension ShortFormSearchHeader {
    func configureLayout() {
        
//        stackView.backgroundColor = .red
        
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.right.bottom.equalToSuperview()
//            $0.edges.equalToSuperview()
        }
        
        recentBackground.snp.makeConstraints {
            $0.top.left.height.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        recentButton.snp.makeConstraints {
            $0.center.equalTo(recentBackground)
        }
        
        popularBackground.snp.makeConstraints {
            $0.left.equalTo(recentBackground.snp.right).offset(10)
            $0.top.width.bottom.equalTo(recentBackground)
        }
        
        popularButton.snp.makeConstraints {
            $0.center.equalTo(popularBackground)
        }
        
        minimumBackground.snp.makeConstraints {
            $0.left.equalTo(popularBackground.snp.right).offset(10)
            $0.top.width.bottom.equalTo(recentBackground)
        }
        
        minimumButton.snp.makeConstraints {
            $0.center.equalTo(minimumBackground)
        }
        
    }
}

//MARK: - Method(Rx bind)
extension ShortFormSearchHeader {}

#if DEBUG
import SwiftUI
struct ForShortFormSearchHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormSearchHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForShortFormSearchHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormSearchHeader()
            .previewLayout(.fixed(width: 350, height: 35))
    }
}
#endif
