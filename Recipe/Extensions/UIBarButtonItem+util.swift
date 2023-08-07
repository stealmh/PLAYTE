//
//  UIBarButtonItem+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit

extension UIBarButtonItem {

    /// 메뉴버튼 커스텀
    static func menuButton(_ target: Any?,
                           action: Selector,
                           imageName: String,
                           size:CGSize = CGSize(width: 100, height: 40)) -> UIBarButtonItem
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true

        return menuBarItem
    }
    
    /// 메뉴버튼 커스텀
    static func menuButton(
                           imageName: String,
                           size:CGSize = CGSize(width: 100, height: 40)) -> UIBarButtonItem
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal), for: .normal)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true

        return menuBarItem
    }
    
    /// cornerRadius가 들어간 버튼
    static func menuButton(name: String,
                           color: UIColor,
                           cornerRadius: CGFloat?,
                           size:CGSize = CGSize(width: 100, height: 40)) -> UIBarButtonItem
    {
        let button = UIButton(type: .system)
        button.setTitle(name, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = cornerRadius ?? 0.0

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true

        return menuBarItem
    }
    
    /// 이미지에 레이블까지 들어간 메뉴버튼입니다.
    static func menuButtonWithLabel(
                           imageName: String,
                           size:CGSize = CGSize(width: 150, height: 40)) -> UIBarButtonItem
    {
        let button = UIButton(type: .system)
        button.setTitle("Shorts", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal), for: .normal)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true

        return menuBarItem
    }

    static func menuButtonTap(imageName: String, size: CGSize) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(origin: .zero, size: size)
        return UIBarButtonItem(customView: button)
    }
}
