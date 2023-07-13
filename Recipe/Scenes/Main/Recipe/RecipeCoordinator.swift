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
    
    var type: CoordinatorType { .community }
    
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
        ///Todo: Memory leak
//        goVC.didSendEventClosure = { [weak self] event in
//            switch event {
//            case .showFloatingView:
//                print("yes")
//                let vc = PopupViewController()
//                vc.modalPresentationStyle = .overCurrentContext
////                self.tabBarController?.tabBar.layer.zPosition = -1
//                goVC.present(vc, animated: false)
//                return
//            }
//        }
        navigationController.pushViewController(goVC, animated: true)
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
