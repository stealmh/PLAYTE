//
//  CookTimeSettingCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CookSettingCell: UICollectionViewCell {
    
    ///UI Properties
    private let cookTimeTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 10
        v.keyboardType = .numberPad
        return v
    }()
    private let cookTimeTextFieldLabel: UILabel = {
        let v = UILabel()
        v.text = "분"
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    private let decreaseButton: DefaultCircleButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "minus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = .gray.withAlphaComponent(0.4)
        v.tintColor = .white
        return v
    }()
    
    private let serviceCountLabel: UILabel = {
        let v = UILabel()
        v.text = "0"
        v.font = .boldSystemFont(ofSize: 20)
        v.textColor = .mainColor
        v.textAlignment = .center
        return v
    }()
    
    private let increaseButton: UIButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "plus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        v.tintColor = .white
        return v
    }()
    ///Properties
    private let disposeBag = DisposeBag()
    var serviceCountRx = BehaviorRelay(value: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
        cookTimeTextField.delegate = self
        serviceCountLabel.text = "\(serviceCountRx.value)"
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension CookSettingCell {
    
    private func addViews() {
        addSubViews(cookTimeTextField, cookTimeTextFieldLabel, decreaseButton, serviceCountLabel, increaseButton)
    }
    
    private func configureLayout() {
        cookTimeTextField.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(130)
        }
        
        cookTimeTextFieldLabel.snp.makeConstraints {
            $0.centerY.equalTo(cookTimeTextField)
            $0.right.equalTo(cookTimeTextField).offset(20)
        }
        
        decreaseButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(self.snp.centerX).offset(30)
            $0.width.height.equalTo(44)
        }
        
        serviceCountLabel.snp.makeConstraints {
            $0.top.equalTo(decreaseButton.snp.centerY).offset(-10)
            $0.left.equalTo(decreaseButton.snp.right).offset(20)
            $0.right.equalTo(increaseButton.snp.left).inset(-20)
        }
        
        increaseButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(decreaseButton)
            $0.left.equalTo(serviceCountLabel.snp.right).offset(30)
        }
    }
}

extension CookSettingCell {
    func bind() {
        increaseButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let newValue = (self?.serviceCountRx.value ?? 0) + 1
                self?.serviceCountRx.accept(newValue)
            }).disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let newValue = (self?.serviceCountRx.value ?? 0) - 1
                if newValue >= 0 {
                    self?.serviceCountRx.accept(newValue)
                }
            }).disposed(by: disposeBag)
        
        serviceCountRx
            .debug()
            .map { String($0) }
            .bind(to: serviceCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CookSettingCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForCookTimeSettingCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CookSettingCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CookTimeSettingCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCookTimeSettingCell()
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
