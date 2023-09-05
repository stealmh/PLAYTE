//
//  AddIngredientDefaultView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol AddIngredientDefaultViewDelegate: AnyObject {
    func didTappedCancelButton()
    func didTappedOkButton(_ count: Int)
}

class AddIngredientDefaultView: UIView {
    
    private let ingredientTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20)
        v.textColor = .black
        return v
    }()
    
    private let countTextField: UITextField = {
        let v = UITextField()
        v.font = .systemFont(ofSize: 17)
        v.contentVerticalAlignment = .center
        v.textAlignment = .center
        v.keyboardType = .numberPad
        return v
    }()
    
    private let deleteTextFieldButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "multi_svg"), for: .normal)
        v.isHidden = true
        return v
    }()
    
    private let textFieldUnderLine: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.grayScale4?.cgColor
        return v
    }()
    
    private let okButton: UIButton = {
        let v = UIButton()
        v.setTitle("확인", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    
    private let cancelButton: UIButton = {
        let v = UIButton()
        v.setTitle("취소", for: .normal)
        v.setTitleColor(.grayScale4, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        return v
    }()
    
    var count = 0
    private let disposeBag = DisposeBag()
    weak var delegate: AddIngredientCountViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        backgroundColor = .white
        addSubViews(ingredientTitle, okButton, cancelButton, countTextField, deleteTextFieldButton, textFieldUnderLine)
        configureLayout()
        bind()
        countTextField.delegate = self
        mockConfigure(IngredientInfo(ingredient_id: 0, ingredient_name: "간장", ingredient_type: "", ingredient_unit: "g"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddIngredientDefaultView {
    func configureLayout() {
        ingredientTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
    
        countTextField.snp.makeConstraints {
            $0.top.equalTo(ingredientTitle.snp.bottom).offset(10)
            $0.centerX.equalTo(ingredientTitle)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(21)
        }
        
        deleteTextFieldButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.left.equalTo(countTextField.snp.right).inset(10)
            $0.top.equalTo(countTextField).offset(-5)
        }
        
        textFieldUnderLine.snp.makeConstraints {
            $0.top.equalTo(countTextField.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(15)
        }
                
        okButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(textFieldUnderLine.snp.bottom).offset(20)
            $0.height.equalTo(46)
        }
    }
    
    func bind() {
        okButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedOkButton(self.count)
                print(self.count)
            }).disposed(by: disposeBag)
    
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedCancelButton()
            }).disposed(by: disposeBag)
        
        countTextField.rx.text.orEmpty
            .subscribe(onNext: { txt in
                print(txt.isEmpty)
                self.deleteTextFieldButton.isHidden = txt.isEmpty
                self.okButton.isEnabled = !txt.isEmpty
                self.okButton.backgroundColor = txt.isEmpty ? .grayScale3 : .mainColor
                self.count = Int(txt) ?? 0
            }).disposed(by: disposeBag)
        
        deleteTextFieldButton.rx.tap
            .subscribe(onNext: { _ in
                self.countTextField.text = ""
                self.count = 0
                self.deleteTextFieldButton.isHidden = true
                self.okButton.isEnabled = false
                self.okButton.backgroundColor = .grayScale3
            }).disposed(by: disposeBag)
    }
    
    func mockConfigure(_ item: IngredientInfo) {
        ingredientTitle.text = "\(item.ingredient_name) \(item.ingredient_unit)"
        ingredientTitle.asColor(targetString: "type", color: .mainColor ?? .black)
        countTextField.placeholder = "필요한 양(\(item.ingredient_unit))을 입력해주세요"
    }
    
    func configure(_ item: IngredientInfo) {
        var type: String = ""
        switch item.ingredient_unit {
        case "ML":
            type = "mL"
        case "G":
            type = "g"
        case "T":
            type = "T"
        default: return
        }
        
        ingredientTitle.text = "\(item.ingredient_name) \(type)"
        ingredientTitle.asColor(targetString: type, color: .mainColor ?? .black)
        countTextField.placeholder = "필요한 양(\(type))을 입력해주세요"
    }
}

extension AddIngredientDefaultView: UITextFieldDelegate {
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

#if DEBUG
import SwiftUI
struct ForAddIngredientDefaultView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        AddIngredientDefaultView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct AddIngredientDefaultView_Preview: PreviewProvider {
    static var previews: some View {
        ForAddIngredientDefaultView()
            .previewLayout(.fixed(width: 327, height: 205))
    }
}
#endif
