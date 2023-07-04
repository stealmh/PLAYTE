//
//  HomeViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let titleView = TitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationTabBar()
    }

}

/// Method - Normal
extension HomeViewController {
    func configureNavigationTabBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "popcat", size: CGSize(width: 40, height: 40))
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.titleView = titleView
    }
}
