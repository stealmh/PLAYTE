//
//  AddIngredientCountView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol AddIngredientCountViewDelegate: AnyObject {
    func didTappedCancelButton()
    func didTappedOkButton(_ count: Int)
}

class AddIngredientCountView: UIView {
    
    private let ingredientTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20)
        v.text = "토마토 개"
        v.textColor = .black
        return v
    }()
    
    private let increaseButton: UIButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "plus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = .mainColor
        v.tintColor = .white
        return v
    }()
    
    private let countLabel: UILabel = {
        let v = UILabel()
        v.textColor = .mainColor
        v.font = .systemFont(ofSize: 24)
        v.textAlignment = .center
        return v
    }()
    
    private let decreaseButton: UIButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "minus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = .grayScale3
        v.tintColor = .white
        return v
    }()
    
    private let okButton: UIButton = {
        let v = UIButton()
        v.setTitle("확인", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    private let cancelButton: UIButton = {
        let v = UIButton()
        v.setTitle("취소", for: .normal)
        v.setTitleColor(.grayScale4, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private var count = 0
    private let disposeBag = DisposeBag()
    weak var delegate: AddIngredientCountViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        addSubViews(ingredientTitle, increaseButton, decreaseButton, okButton, cancelButton, countLabel)
        configureLayout()
        bind()
        countLabel.text = "\(count)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddIngredientCountView {
    func configureLayout() {
        ingredientTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(15)
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(ingredientTitle.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(29)
            $0.width.greaterThanOrEqualTo(30)
        }
        increaseButton.snp.makeConstraints {
            $0.left.equalTo(countLabel.snp.right).offset(30)
            $0.centerY.equalTo(countLabel)
            $0.width.height.equalTo(50)
        }
        decreaseButton.snp.makeConstraints {
            $0.right.equalTo(countLabel.snp.left).offset(-30)
            $0.centerY.equalTo(countLabel)
            $0.width.height.equalTo(50)
        }
        okButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(decreaseButton.snp.bottom).offset(20)
            $0.height.equalTo(46)
        }
    }
    
    func bind() {
        decreaseButton.rx.tap
            .subscribe(onNext: { _ in
                if self.count > 0 {
                    self.count -= 1
                    self.countLabel.text = "\(self.count)"
                }
            }).disposed(by: disposeBag)
        
        increaseButton.rx.tap
            .subscribe(onNext: { _ in
                self.count += 1
                self.countLabel.text = "\(self.count)"
            }).disposed(by: disposeBag)
        
        okButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedOkButton(self.count)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedCancelButton()
            }).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForAddIngredientCountView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        AddIngredientCountView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct AddIngredientCountView_Preview: PreviewProvider {
    static var previews: some View {
        ForAddIngredientCountView()
            .previewLayout(.fixed(width: 327, height: 205))
    }
}
#endif
