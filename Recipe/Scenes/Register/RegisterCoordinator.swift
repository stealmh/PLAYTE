//
//  RegisterCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol RegisterCoordinatorProtocol: Coordinator {
    func showRegisterViewController()
}

final class RegisterCoordinator: RegisterCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .register }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRegisterViewController()
    }
    
    deinit {
        print("🍎\(String(describing: Self.self)) deinit.")
    }
    
    func showRegisterViewController() {
        let registerVC: RegisterFirstViewController = .init()
        registerVC.delegate = self
        navigationController.pushViewController(registerVC, animated: true)
    }
}

extension RegisterCoordinator: RegisterFlowDelegate {
    
    func moveToSecondView() {
        let vc = RegisterSecondViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func endFlow() {
        self.finish()
    }
}
