//
//  RegisterFirstViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol RegisterFlowDelegate {
    func moveToSecondView()
    func endFlow()
}

final class RegisterFirstViewController: BaseViewController {

    var didSendEventClosure: ((RegisterFirstViewController.Event) -> Void)?
    var delegate: RegisterFlowDelegate?
    
    private let secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("[1] Move to Second View", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(secondButton)

        secondButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            secondButton.widthAnchor.constraint(equalToConstant: 200),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        secondButton.addTarget(self, action: #selector(didTapSteadyButton(_:)), for: .touchUpInside)
    }

    @objc private func didTapSteadyButton(_ sender: Any) {
//        didSendEventClosure?(.showSecondView)
        delegate?.moveToSecondView()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        delegate?.endFlow()
//    }
}

extension RegisterFirstViewController {
    enum Event {
        case showSecondView
    }
}
