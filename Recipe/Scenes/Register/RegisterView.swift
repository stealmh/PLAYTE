//
//  RegisterView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol registerViewDelegate {
    func didTapNextButton()
}

final class RegisterView: UIView {
    
    ///UI Properties
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "사용하실 닉네임을 입력해주세요"
        v.font = .boldSystemFont(ofSize: 22)
        v.textColor = .white
        return v
    }()
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "식재료를 검색해보세요."
        v.layer.cornerRadius = 8
        v.textColor = .white
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "multiply.circle.fill")!, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .gray
        return v
    }()
    
    private let nextButton: UIButton = {
        let v = UIButton()
        v.setTitle("다음", for: .normal)
        v.tintColor = .white
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    var delegate: registerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubViews(titleLabel, searchTextField, searchImageButton, nextButton)
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method
extension RegisterView {
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.top.equalTo(154)
            $0.height.equalTo(26)
            $0.width.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel).offset(237-154)
            $0.height.equalTo(56)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextField).inset(7)
            $0.width.equalTo(searchTextField.snp.height)
            $0.right.equalTo(searchTextField).inset(10)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(searchTextField)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    func bind() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTapNextButton()
            }
        ).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForRegisterView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RegisterView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RegisterView_Preview: PreviewProvider {
    static var previews: some View {
        ForRegisterView()
    }
}
#endif
