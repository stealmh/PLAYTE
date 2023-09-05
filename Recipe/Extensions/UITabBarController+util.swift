//
//  UITabBarController+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/01.
//

import UIKit

extension UITabBarController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.changedHeightOfTabBar(addedHeight: 20)
//        self.changedHeightOfTabBar(setHeight: 100)
        
    }

    func changedHeightOfTabBar(setHeight: Double) {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = setHeight
        tabFrame.origin.y = view.frame.size.height - setHeight
        self.tabBar.frame = tabFrame
    }
    
    func changedHeightOfTabBar(addedHeight: CGFloat) {
        let newHeight = tabBar.frame.size.height + addedHeight
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = newHeight
        tabFrame.origin.y = view.frame.size.height - newHeight
        self.tabBar.frame = tabFrame
    }
}
