//
//  RegisterSecondViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit

final class RegisterSecondViewController: BaseViewController {

    var didSendEventClosure: ((RegisterSecondViewController.Event) -> Void)?
    var delegate: RegisterFlowDelegate?
    
    private let registerSucessView = RegisterSucessView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(registerSucessView)
        registerSucessView.delegate = self
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        registerSucessView.delegate = nil
    }
    
}

//MARK: - Method(Normal)
extension RegisterSecondViewController {
    func configureLayout() {
        registerSucessView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - Method(RegisterSucessView Delegate)
extension RegisterSecondViewController: RegisterViewDelegate {
    func didTapNextButton() {
        delegate?.endFlow()
    }
}

extension RegisterSecondViewController {
    enum Event {
        case endFlow
    }
}
