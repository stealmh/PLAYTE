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

protocol RegisterViewDelegate {
    func didTapNextButton(_ txt: String) async
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
        v.backgroundColor = .black
//        v.placeholder = "식재료를 검색해보세요."
        v.tintColor = .white
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
    
    private let validationImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "checkmark")!
        v.tintColor = .white
        return v
    }()
    
    private let validationLabel: UILabel = {
        let v = UILabel()
        v.text = "사용가능한 닉네임"
        v.textColor = .white
        return v
    }()
    
    private let nextButton: UIButton = {
        let v = UIButton()
        v.setTitle("다음", for: .normal)
        v.tintColor = .white
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    var delegate: RegisterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubViews(titleLabel,
                    searchTextField,
                    searchImageButton,
                    nextButton,
                    validationImage,
                    validationLabel)
        
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method
extension RegisterView {
    private func configureLayout() {
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
        
        validationImage.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.top).offset(307-237)
            $0.right.equalTo(validationLabel.snp.left)
        }
        
        validationLabel.snp.makeConstraints {
            $0.top.equalTo(validationImage).offset(3)
            $0.right.equalTo(searchTextField).inset(10)
            $0.height.equalTo(15)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(searchTextField)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func bind() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                Task {
                    await self.delegate?.didTapNextButton(self.searchTextField.text!)
                }
            }
        ).disposed(by: disposeBag)
        
        searchImageButton.rx.tap
            .subscribe(onNext: { _ in
                self.searchTextField.text = ""
            }
        ).disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { txt in
                if !txt.isEmpty {
                    LoginService.shared.nickNameCheck(nickName: txt, completion: { data in
                        DispatchQueue.main.async {
                            self.validationLabel.text = "\(!data)"
                            self.nextButton.isEnabled = !data
                            self.nextButton.backgroundColor = self.nextButton.isEnabled ? .mainColor : .gray
                        }
                    })
                }
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
