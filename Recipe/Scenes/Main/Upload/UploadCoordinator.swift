//
//  CommunityCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/07.
//

import UIKit

final class UploadCoordinator: MypageCoordinatorProtocol, CoordinatorFinishDelegate {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .upload }
    
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
        let goVC = PopupViewController()
        goVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .showCreateRecipeView:
                self?.showCreateRecipeView()
                return
            }
        }
        navigationController.pushViewController(goVC, animated: true)
    }
    
    func showCreateRecipeView() {
        let vc = CreateRecipeViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSendEventClosure = { [weak self] event in
            switch event {
            case .registerButtonTapped:
                self?.navigationController.popViewController(animated: true)
                return
            }
        }
        self.navigationController.dismiss(animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
}

extension UploadCoordinator {
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
