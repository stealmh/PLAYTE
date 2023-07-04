//
//  GoCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol GoCoordinatorProtocol: Coordinator {
    func startReadyFlow()
}

final class GoCoordinator: GoCoordinatorProtocol, CoordinatorFinishDelegate {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .myPage }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startReadyFlow()
    }
    
    deinit {
        print("🍎\(String(describing: Self.self)) deinit.")
    }
    
    func showRegisterFlow() {
        let registerCoordinator = RegisterCoordinator(navigationController)
        registerCoordinator.finishDelegate = self
        registerCoordinator.start()
        childCoordinators.append(registerCoordinator)
    }
    
    func startReadyFlow()  {
        let goVC = GoViewController()
        goVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .go:
                self?.finishDelegate?.coordinatorDidFinish(childCoordinator: self!)
                return
            }
        }
        navigationController.pushViewController(goVC, animated: true)
    }
}

extension GoCoordinator {
    func deleteChild(_ child: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .register:
            navigationController.viewControllers.removeAll()
            startReadyFlow()
        default:
            break
        }
    }
}
