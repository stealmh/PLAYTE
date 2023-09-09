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

protocol RegisterViewDelegate: AnyObject {
    func didTapNextButton(_ txt: String) async
}

final class RegisterView: UIView {
    
    ///UI Properties
    private let registerImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "register")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "반가워요!\n제가 뭐라고 부르면 될까요?"
        v.font = .boldSystemFont(ofSize: 22)
        v.textColor = .black
        v.numberOfLines = 2
        return v
    }()
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .grayScale1
        v.placeholder = "닉네임을 입력해주세요."
        v.tintColor = .mainColor
        v.layer.cornerRadius = 8
        v.textColor = .mainColor
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "nickNameCheck")!, for: .normal)
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        return v
    }()
    
    private let validationLabel: UILabel = {
        let v = UILabel()
        v.text = "사용가능한 닉네임입니다."
        v.textColor = .mainColor
        v.isHidden = true
        return v
    }()
    
    private let nextButton: UIButton = {
        let v = UIButton()
        v.setTitle("렛츠 플레이트!", for: .normal)
        v.tintColor = .white
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    
    ///Properties
    private var viewModel = RegisterViewModel()
    private var disposeBag = DisposeBag()
    weak var delegate: RegisterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAddView()
        setupLayout()
        setupRxBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("RegisterView deinit")
    }
}

//MARK: - Method
extension RegisterView {
    private func setupAddView() {
        addSubViews(registerImageView,
                    titleLabel,
                    searchTextField,
                    searchImageButton,
                    nextButton,
                    validationLabel)
    }
    
    private func setupLayout() {
        registerImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.width.equalToSuperview().inset(50)
            $0.top.equalTo(registerImageView.snp.bottom).offset(50)
            $0.left.equalTo(searchTextField).inset(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextField)
            $0.width.equalTo(searchTextField.snp.height)
            $0.right.equalTo(searchTextField).inset(10)
        }
        
        validationLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.right.equalTo(searchTextField).inset(10)
            $0.height.equalTo(15)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(searchTextField)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func setupRxBindings() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                Task { await self.delegate?.didTapNextButton(self.searchTextField.text!) }
            }).disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .skip(1)
            .bind(to: viewModel.nickNameInput)
            .disposed(by: disposeBag)
        
        viewModel.isNickNameValid
            .drive(onNext: { [weak self] (isValid, nickName) in
                !nickName.isValidNickname() ?
                self?.inValidNickNameCheck() : self?.teamNickNameCheck(!isValid, nickName)
            }).disposed(by: disposeBag)
        
    }
}

//MARK: Method(Normal)
extension RegisterView {
    private func teamNickNameCheck(_ valid: Bool, _ txt: String) {
        searchTextField.layer.borderColor = UIColor.mainColor?.cgColor
        searchTextField.textColor = .mainColor
        searchTextField.backgroundColor = .sub1
        if valid {
            searchImageButton.isHidden = false
            searchImageButton.setImage(UIImage(named: "nickNameCheck")!, for: .normal)
            validationLabel.isHidden = false
            nextButton.backgroundColor = .mainColor
            nextButton.isEnabled = true
            switch txt {
            case "초코칩":
                validationLabel.text = "(민트)초코칩 반가워요 꺄르륵^^"
            case "채채":
                validationLabel.text = "디자인 너무 머쉿따.. 채채 반가워요!"
            case "제제":
                validationLabel.text = "멋진 기획자 제제 반가워요!"
            default:
                validationLabel.text = "사용 가능한 닉네임 입니다"
            }
        } else {
            searchImageButton.isHidden = false
            searchImageButton.setImage(UIImage(named: "nickNameError")!, for: .normal)
            validationLabel.text = "중복된 닉네임입니다"
            validationLabel.isHidden = false
            nextButton.backgroundColor = .grayScale3
            nextButton.isEnabled = false
        }
    }
    
    private func inValidNickNameCheck() {
        searchImageButton.isHidden = false
        searchImageButton.setImage(UIImage(named: "nickNameError")!, for: .normal)
        validationLabel.text = "잘못된 닉네임 형식입니다"
        validationLabel.isHidden = false
        nextButton.backgroundColor = .grayScale3
        nextButton.isEnabled = false
    }
}

//MARK: - VC Preview
import SwiftUI
struct ShortFormViewControll1er1_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: RegisterFirstViewController())
            .toPreview()
    }
}
