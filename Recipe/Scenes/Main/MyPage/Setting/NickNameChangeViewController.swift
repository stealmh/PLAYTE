//
//  NickNameChangeViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NickNameChangeViewController: BaseViewController {
    
    private let whiteBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let guideLabel: UILabel = {
        let v = UILabel()
        v.text = "닉네임은 1일 1회까지만 변경할 수 있습니다."
        v.font = .systemFont(ofSize: 14)
        v.textColor = UIColor.hexStringToUIColor(hex: "B8B8B8")
        v.asColor(targetString: "1일 1회", color: .mainColor ?? .orange)
        v.textAlignment = .center
        return v
    }()
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .grayScale1
        v.placeholder = "닉네임을 입력해주세요." /// 닉네임 값 넣기
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
        v.setImage(UIImage(named: "pencil_svg")!, for: .normal)
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        v.isEnabled = false
        return v
    }()
    
    private let validationLabel: UILabel = {
        let v = UILabel()
        v.text = "사용가능한 닉네임입니다."
        v.textColor = .mainColor
        v.isHidden = true
        return v
    }()
    
    private let saveButton: UIButton = {
        let v = UIButton()
        v.setTitle("저장", for: .normal)
        v.tintColor = .white
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    var nickName = ""

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale2
        addView()
        configureLayout()
        configureNavigationBar()
        bind()
    }

}

//MARK: Method(Normal)
extension NickNameChangeViewController {
    func addView() {
        view.addSubview(whiteBackground)
        view.addSubview(guideLabel)
        view.addSubview(searchTextField)
        view.addSubview(searchImageButton)
        view.addSubview(validationLabel)
        view.addSubview(saveButton)
    }
    
    func configureLayout() {
        whiteBackground.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(210)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(14)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(50)
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
        
        saveButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(searchTextField)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    func configureNavigationBar() {
        title = "닉네임 관리"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .black)
    }
    
    private func bind() {
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                ///
                let parameter = ["nickname:": self.nickName]
                Task {
                    LoginService.shared.nickNameChange(nickName: self.nickName) { data in
                        print(data)
                        if data.code == "SUCCESS" {
                            self.saveChangeDate()
                            self.dismiss(animated: true)
                        }
                    }
                    
//                    
//                    do {
//                        print("제 파라미터입니다: ",parameter)
//                        let data1: ReviewResult = try await NetworkManager.shared.get(.nickNameChange, parameters: parameter)
//                        if data1.code == "SUCCESS" {
//                            self.saveChangeDate()
//                            self.dismiss(animated: true)
//                        }
//                    } catch {
//                        print(error)
//                    }
                }
            }
        ).disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { txt in
                print(txt)
                if !txt.isEmpty {
                    self.nickName = txt
                    
                    if self.canChangeNickname() {
                        LoginService.shared.nickNameCheck(nickName: txt, completion: { data in
                            DispatchQueue.main.async {
                                if !txt.isValidNickname() {
                                    self.inValidNickNameCheck()
                                } else {
                                    self.nickNameCheckUI(!data)
                                }
                            }
                        })
                    } else {
                        self.notOneDay()
                    }
                }
            }
        ).disposed(by: disposeBag)
    }
    
    func nickNameCheckUI(_ valid: Bool) {
        searchTextField.layer.borderColor = UIColor.mainColor?.cgColor
        searchTextField.textColor = .mainColor
        searchTextField.backgroundColor = .sub1
        if valid {
            searchImageButton.isHidden = false
            searchImageButton.setImage(UIImage(named: "nickNameCheck")!, for: .normal)
            validationLabel.isHidden = false
            validationLabel.text = "사용 가능한 닉네임 입니다"
            saveButton.backgroundColor = .mainColor
            saveButton.isEnabled = true
        } else {
            searchImageButton.isHidden = false
            searchImageButton.setImage(UIImage(named: "nickNameError")!, for: .normal)
            validationLabel.text = "중복된 닉네임 입니다"
            validationLabel.isHidden = false
            saveButton.backgroundColor = .grayScale3
            saveButton.isEnabled = false
        }
    }
    
    func inValidNickNameCheck() {
        searchImageButton.isHidden = false
        searchImageButton.setImage(UIImage(named: "nickNameError")!, for: .normal)
        validationLabel.text = "잘못된 닉네임 형식입니다"
        validationLabel.isHidden = false
        saveButton.backgroundColor = .grayScale3
        saveButton.isEnabled = false
    }
    
    func notOneDay() {
        searchImageButton.isHidden = false
        searchImageButton.setImage(UIImage(named: "nickNameError")!, for: .normal)
        validationLabel.text = "하루에 한 번만 닉네임을 변경할 수 있습니다."
        validationLabel.isHidden = false
        saveButton.backgroundColor = .grayScale3
        saveButton.isEnabled = false
    }
    
    func saveChangeDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "nicknameLastChangedDate")
    }
    
    func canChangeNickname() -> Bool {
        if let lastChangedDate = UserDefaults.standard.object(forKey: "nicknameLastChangedDate") as? Date {
            if let difference = Calendar.current.dateComponents([.hour], from: lastChangedDate, to: Date()).hour, difference < 24 {
                return false
            }
        }
        return true
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct NickNameChangeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: NickNameChangeViewController())
            .toPreview().ignoresSafeArea()
    }
}
