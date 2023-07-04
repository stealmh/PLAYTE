//
//  SplashCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol SplashCoordinatorProtocol: Coordinator {
    func showSplashView()
}

final class SplashCoordinator: SplashCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .splash }
    
    var isUserAccount: Bool = false
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showSplashView()
    }
    
    deinit {
        print("🍎\(String(describing: Self.self)) deinit.")
    }
    
    func showSplashView() {
        let splashVC: SplashViewController = .init()
        splashVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .endSplash:
                self?.finish()
            }
        }
        
        navigationController.pushViewController(splashVC, animated: true)
    }
}
