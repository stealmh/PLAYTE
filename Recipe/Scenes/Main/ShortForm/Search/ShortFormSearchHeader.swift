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
    let recentButton = RecipeDefaultTagButton(tagName: "최신순", tag: 0)
    let popularButton = RecipeDefaultTagButton(tagName: "인기순", tag: 1)
    let minimumButton = RecipeDefaultTagButton(tagName: "최소 시간순", tag: 2)
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        return v
    }()
    /// Properties
    private let disposeBag = DisposeBag()
    private let buttonTappedSubject = BehaviorRelay<Int>(value: 0)
    private lazy var tagBackgrounds = [recentBackground, popularBackground, minimumBackground]
    private lazy var tagButtons = [recentButton, popularButton, minimumButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        recentBackground.addSubview(recentButton)
        popularBackground.addSubview(popularButton)
        minimumBackground.addSubview(minimumButton)
        stackView.addArrangeViews(recentBackground, popularBackground, minimumBackground)
        addSubViews(stackView)
        configureLayout()
        recentButton.setTitleColor(.white, for: .normal)
        bind()
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
            $0.width.equalTo(55)
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
            $0.top.bottom.equalTo(recentBackground)
            $0.width.equalTo(75)
        }
        
        minimumButton.snp.makeConstraints {
            $0.center.equalTo(minimumBackground)
        }
        
    }
}

//MARK: - Method(Rx bind)
extension ShortFormSearchHeader {
    private func bind() {
        tagButtons.forEach { btn in
            btn.rx.tap
                .subscribe(onNext: { _ in
                    self.buttonTappedSubject.accept(btn.tag)
                }
            ).disposed(by: disposeBag)
        }
        
        buttonTappedSubject.subscribe(onNext: { tagNumber in
            print(tagNumber)
            self.tagButtons.forEach {
                if $0.tag == tagNumber {
                    self.tagBackgrounds
                        .filter { $0 == self.tagBackgrounds[tagNumber]}
                        .forEach { $0.backgroundColor = .mainColor }
                    $0.setTitleColor(.white, for: .normal)
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
                } else {
                    self.tagBackgrounds
                        .filter { $0 != self.tagBackgrounds[tagNumber]}
                        .forEach { $0.backgroundColor = .sub1 }
                    $0.setTitleColor(.mainColor, for: .normal)
                    $0.titleLabel?.font = .systemFont(ofSize: 12)
                }
            }
        }).disposed(by: disposeBag)
    }

}

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
