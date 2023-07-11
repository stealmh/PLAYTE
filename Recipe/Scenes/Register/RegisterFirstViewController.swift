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
extension RegisterFirstViewController: registerViewDelegate {
    func didTapNextButton() {
        delegate?.moveToSecondView()
    }
}
