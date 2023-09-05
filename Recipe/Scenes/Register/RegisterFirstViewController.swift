//
//  RegisterFirstViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit

protocol RegisterFlowDelegate {
    func endFlow()
    func registerFail()
}

final class RegisterFirstViewController: BaseViewController {
    var delegate: RegisterFlowDelegate?
    private let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registerView)
        registerView.delegate = self
        configureLayout()
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .gray)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        registerView.delegate = nil
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode is active
            return .lightContent // Set the status bar style to light content
        } else {
            // Light mode is active
            return .darkContent
        }
    }
    
}

//MARK: - Method
extension RegisterFirstViewController {
    func configureLayout() {
        registerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - RegisterView Delegate
extension RegisterFirstViewController: RegisterViewDelegate {
    func didTapNextButton(_ txt: String) async {
        let data = try? await LoginService.shared.appleRegister(
            idToken: KeyChain.shared.read(account: .idToken), nickName: txt)

        if (data != nil), data?.message == "성공" {
            self.delegate?.endFlow()
        }
        
        if data == nil {
            let data2 = try? await LoginService.shared.googleRegister(
                idToken: KeyChain.shared.read(account: .idToken), nickName: txt)
            print(data2!)
            if (data2 != nil), data2?.message == "성공" {
                self.delegate?.endFlow()
            }
        }

    }
}
