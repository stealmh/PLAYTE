//
//  RegisterFirstViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit

protocol RegisterFlowDelegate {
    func moveToSecondView()
    func endFlow()
    func registerFail()
}

final class RegisterFirstViewController: BaseViewController {
    var delegate: RegisterFlowDelegate?
    private let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(registerView)
        registerView.delegate = self
        configureLayout()
        defaultNavigationBackButton(backButtonColor: .white)
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
    func didTapNextButton(_ txt: String) {
        LoginService.shared.appleRegister(
            idToken: KeyChain.shared.read(account: .idToken),
            nickName: txt) { result in
                switch result {
                case .success:
                    self.delegate?.moveToSecondView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
