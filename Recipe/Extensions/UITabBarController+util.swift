//
//  UITabBarController+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/01.
//

import UIKit

extension UITabBarController {
    
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.changedHeightOfTabBar(setHeight: 100)
    }
    
    func changedHeightOfTabBar(setHeight: Double) {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = setHeight
        tabFrame.origin.y = view.frame.size.height - setHeight
        self.tabBar.frame = tabFrame
    }
}
