//
//  AppCoordinator.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/03.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showSplashFlow()
    func showLoginFlow()
    func showMainFlow()
}

class AppCoordinator: NSObject, AppCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    var window: UIWindow?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        showSplashFlow()
        navigationController.delegate = self
    }
    
    func showSplashFlow() {
        let splashCoordinator = SplashCoordinator.init(navigationController)
        splashCoordinator.finishDelegate = self
        splashCoordinator.start()
        childCoordinators.append(splashCoordinator)
    }
    
    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator.init(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
        window?.rootViewController = loginCoordinator.navigationController
    }
    
    func showMainFlow() {
//        let tabCoordinator = TabCoordinator.init(navigationController)
//        tabCoordinator.finishDelegate = self
//        tabCoordinator.start()
//        childCoordinators.append(tabCoordinator)
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.finishDelegate = self
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
        window?.rootViewController = tabCoordinator.tabBarController
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .splash:
//            navigationController.viewControllers.removeAll()
//            let a = childCoordinator as! SplashCoordinator
            LoginService.shared.appleLogin(accessToken: KeyChain.shared.read(account: .idToken)) { result in
                switch result {
                case .success(let data):
                    self.navigationController.viewControllers.removeAll()
                    if data.data.isMember {
                        self.showMainFlow()
                    } else {
                        self.showLoginFlow()
                    }
                case .failure(let data): ///Todo: 에러에 따른 처리추가
                    self.navigationController.viewControllers.removeAll()
                    self.showLoginFlow()
                }
            }
            
        case .tab:
            navigationController.viewControllers.removeAll()
            showLoginFlow()
            
        case .login:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            break
        }
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
           return
        }

        // fromViewController가 navigationController의 viewControllers에 포함되어있으면 return. 왜냐하면 여기에 포함되어있지 않아야 현재 fromViewController 가 사라질 화면을 의미.
        if navigationController.viewControllers.contains(fromViewController) {
           return
        }

        // child coordinator 가 일을 끝냈다고 알림.
        if let leftVC = fromViewController as? RegisterFirstViewController {
            leftVC.delegate?.registerFail()
        }
    }
}
