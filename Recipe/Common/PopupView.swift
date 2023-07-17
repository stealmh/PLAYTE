//
//  PopupView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol PopupViewDelegate {
    func createRecipeButtonTapped()
    func createShortFormButtonTapped()
}

///Todo: 재활용성을 위해 버튼의 레이블은 생성자로 입력받게 수정할 것!
final class PopupView: UIView {
    
    /// UI Properties
    private let addRecipeButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .white
        v.setTitle("나의 레시피 작성", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let makeShortFormButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.setTitle("숏폼 게시", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    /// Properites
    private let disposeBag = DisposeBag()
    var delegate: PopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.2)
        addSubViews(addRecipeButton,makeShortFormButton)
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

//MARK: - Method
extension PopupView {
    func configureLayout() {
        addRecipeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).offset(-15)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
        
        makeShortFormButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }
}

//MARK: - Method(Rx Bind)
extension PopupView {
    func bind() {
        addRecipeButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.createRecipeButtonTapped()
            }
        ).disposed(by: disposeBag)
        
        makeShortFormButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.createShortFormButtonTapped()
            }
        ).disposed(by: disposeBag)
    }
}

import SwiftUI
struct ForPopupView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        PopupView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PopupView_Preview: PreviewProvider {
    static var previews: some View {
        ForPopupView()
//        .previewLayout(.fixed(width: 393, height: 50))
    }
}

