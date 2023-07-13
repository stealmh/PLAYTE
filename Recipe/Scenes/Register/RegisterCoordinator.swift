//
//  RegisterCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol RegisterCoorProtocol {
    func failRegister(_ coordinator: RegisterCoordinator)
}

final class RegisterCoordinator: RegisterCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var delegate: RegisterCoorProtocol?
    
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
    
    func registerFail() {
        print(#function)
//        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
//        navigationController.popToRootViewController(animated: true)
//        finish()
        delegate?.failRegister(self)
    }
    
    func endFlow() {
        print(#function)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
