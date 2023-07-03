//
//  RegisterSecondViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

final class RegisterSecondViewController: BaseViewController {

    var didSendEventClosure: ((RegisterSecondViewController.Event) -> Void)?
    var delegate: RegisterFlowDelegate?
    
    private let steadyButton: UIButton = {
        let button = UIButton()
        button.setTitle("[2] End Flow", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(steadyButton)

        steadyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            steadyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            steadyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            steadyButton.widthAnchor.constraint(equalToConstant: 200),
            steadyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        steadyButton.addTarget(self, action: #selector(didTapSteadyButton(_:)), for: .touchUpInside)
    }

    @objc private func didTapSteadyButton(_ sender: Any) {
//        didSendEventClosure?(.endFlow)
        delegate?.endFlow()
    }
}

extension RegisterSecondViewController {
    enum Event {
        case endFlow
    }
}
