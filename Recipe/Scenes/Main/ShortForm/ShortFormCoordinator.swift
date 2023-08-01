//
//  ShortFormCoordinator.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/01.
//

import UIKit

final class ShortFormCoordinator: CoordinatorFinishDelegate, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .shortForm }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startReadyFlow()
    }
    
    deinit {
        print("🍎\(String(describing: Self.self)) deinit.")
    }
    
    func startReadyFlow()  {
        let goVC = ShortFormViewController()
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

extension ShortFormCoordinator {
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
