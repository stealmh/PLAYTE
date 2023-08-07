//
//  TabCoordinator.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, TabCoordinatorProtocol, CoordinatorFinishDelegate {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.shortForm, .recipe, .upload, .myPage]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        //        print(controllers)
        
        prepareTabBarController(withTabControllers: controllers)
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        } else {
            tabBarController.tabBar.barTintColor = .white
        }
        
    }
    
    deinit {
        print("🍎\(String(describing: Self.self)) deinit.")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        //        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.recipe.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        //        navigationController.viewControllers = [tabBarController]
        tabBarController.viewControllers = tabControllers
        changeRadius(cornerRadius: 13)
        tabBarController.viewDidLayoutSubviews()
        
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        //        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.tabIcon(),
                                                     tag: page.pageOrderNumber())
        navController.tabBarItem.selectedImage = page.selectedImage()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .mainColor
        tabBarController.tabBar.unselectedItemTintColor = .grayScale5
        
        switch page {
        case .shortForm:
            let readyCoordinator = ShortFormCoordinator(navController)
            readyCoordinator.finishDelegate = self
            childCoordinators.append(readyCoordinator)
            readyCoordinator.start()
            
        case .recipe:
            let readyCoordinator = RecipeCoordinator(navController)
            readyCoordinator.finishDelegate = self
            childCoordinators.append(readyCoordinator)
            readyCoordinator.start()
            
        case .upload:
            let readyCoordinator = UploadCoordinator(navController)
            readyCoordinator.finishDelegate = self
            childCoordinators.append(readyCoordinator)
            readyCoordinator.start()
            
        case .myPage:
            let readyCoordinator = MypageCoordinator(navController)
            readyCoordinator.finishDelegate = self
            childCoordinators.append(readyCoordinator)
            readyCoordinator.start()
            
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    private func changeRadius(cornerRadius: CGFloat) {
        tabBarController.tabBar.layer.masksToBounds = true
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.layer.cornerRadius = cornerRadius
//        tabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
