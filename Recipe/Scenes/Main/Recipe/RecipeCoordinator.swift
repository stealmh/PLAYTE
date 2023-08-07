//
//  RecipeCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/07.
//

import UIKit

final class RecipeCoordinator: MypageCoordinatorProtocol, CoordinatorFinishDelegate {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .recipe }
    
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
        let goVC = RecipeViewController()
        goVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .showFloatingView:
                self?.showPopupView()
                return
            }
        }
        navigationController.pushViewController(goVC, animated: true)
    }
    
    func showPopupView() {
        let vc = PopupViewController()
        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: false) {
            vc.didSendEventClosure = { [weak self] event in
                switch event {
                case .showCreateRecipeView:
                    self?.showCreateRecipeView()
                    return
                }
            }
        }
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

extension RecipeCoordinator {
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
