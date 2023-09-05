//
//  RecipeHeaderCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class RecipeHeaderCell: UICollectionReusableView {
    
    ///UI Properties
    private let recentBackground = RecipeDefaultTagView()
    private let popularBackground = RecipeDefaultTagView()
    private let minimumBackground = RecipeDefaultTagView()
    let recentButton = RecipeDefaultTagButton(tagName:"최신순", tag: 0)
    let popularButton = RecipeDefaultTagButton(tagName:"인기순", tag: 1)
    let minimumButton = RecipeDefaultTagButton(tagName:"최소 시간순", tag: 2)
    /// Constatns Size
    private enum Constants {
        static let tagWidth: Int = 64
        static let tagHeight: Int = 29
    }
    /// Properties
    private let disposeBag = DisposeBag()
    let buttonTappedSubject = BehaviorRelay<Int>(value: 0)
    private lazy var tagBackgrounds = [recentBackground, popularBackground, minimumBackground]
    private lazy var tagButtons = [recentButton, popularButton, minimumButton]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddView()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method
extension RecipeHeaderCell {
    private func setAddView() {
        addSubViews(recentBackground, popularBackground,
                    minimumBackground,
                    recentButton,popularButton,
                    minimumButton)
    }
    
    private func configureLayout() {
        recentBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(Constants.tagWidth)
            $0.height.equalTo(Constants.tagHeight)
        }
        popularBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(recentBackground.snp.right).offset(10)
            $0.width.equalTo(Constants.tagWidth)
            $0.height.equalTo(Constants.tagHeight)
        }
        minimumBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(popularBackground.snp.right).offset(10)
            $0.width.equalTo(Constants.tagWidth + 10)
            $0.height.equalTo(Constants.tagHeight)
        }
        tagButtons.enumerated().forEach { idx, btn in
            btn.snp.makeConstraints {
                $0.center.equalTo(tagBackgrounds[idx])
            }
        }
    }
    
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

//import SwiftUI
//@available(iOS 13.0, *)
//struct RecipeView1_Preview: PreviewProvider {
//    static var previews: some View {
//        ForRecipeView()
//    }
//}
