//
//  UIViewController+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
    func isScrolledToBottom(_ myPosition: CGPoint, _ tableView: UITableView) -> Bool {
        if myPosition.y > tableView.contentSize.height - 100 - tableView.bounds.size.height {
            return true
        }
        return false
    }
    
    /// For Toast Alert
    func showToast(message : String,
                   textColor: UIColor,
                   backgroundColor: UIColor,
                   width:CGFloat,
                   height: CGFloat) {
        let v = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (width/2), y: self.view.frame.size.height-100, width: width, height: height))
        v.backgroundColor = backgroundColor.withAlphaComponent(0.6)
        v.textColor = textColor
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .center
        v.text = message
        v.alpha = 1.0
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        self.view.addSubview(v)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            v.alpha = 0.0
            //아래쪽으로 사라지게 하기 위함
            let scale = CGAffineTransform(translationX: 0, y: 200)
            v.transform = scale
        }, completion: {(isCompleted) in
            v.removeFromSuperview()
        })
    }
    
    func stopPlayAnimation(img: UIImage,
                           width:CGFloat,
                           height: CGFloat) {
        let v = UIImageView(frame: CGRect(x: self.view.frame.size.width/2 - (width/2), y: self.view.frame.size.height-100, width: width, height: height))
        v.image = img
        v.clipsToBounds = true
        self.view.addSubview(v)
        v.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut, animations: {
            v.alpha = 0.0
            //아래쪽으로 사라지게 하기 위함
            let scale = CGAffineTransform(translationX: 0, y: 0)
            v.transform = scale
        }, completion: {(isCompleted) in
            v.removeFromSuperview()
        })
    }
    /// Navigation의 BackButton의 Label을 지우고 "<" 의 색깔을 지정할 수 있습니다.
    //    func defaultNavigationBackButton(backButtonColor: UIColor) {
    //        self.navigationController?.navigationBar.topItem?.title = ""
    //        self.navigationController?.navigationBar.tintColor = backButtonColor
    //    }
    
    func defaultNavigationBackButton(backButtonColor: UIColor, spacing: CGFloat = 15.0) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = backButtonColor
        
        // Create a custom back button
        let backButton = UIButton(type: .custom)
        let backButtonImage = UIImage(named: "backbutton_svg")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal) 
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
        backButton.tintColor = backButtonColor
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Navitaion Large Title의 Alignment를 Center로 바꿔줍니다.
    func centerTitle() {
        for navItem in(self.navigationController?.navigationBar.subviews)! {
            for itemSubView in navItem.subviews {
                if let largeLabel = itemSubView as? UILabel {
                    largeLabel.center = CGPoint(x: navItem.bounds.width/2, y: navItem.bounds.height/2)
                    return
                }
            }
        }
    }
    
    func setNavigationTitle(_ title: String) {
        let v = UILabel()
        v.text = title
        v.font = .boldSystemFont(ofSize: 18)
        v.textColor = .black
        navigationItem.titleView = v
    }
    
    
    func showConfirmationAlert(title: String, message: String, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler?()
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showToastSuccess(message: String) {
        let v = CommonToastView(frame: CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 50))
        v.configureText(message)
        
        // 위치와 크기 조정
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 0
        let yOffset: CGFloat = 70 // y 위치를 50으로 설정
        
        // 화면의 하단에서 탭바의 높이와 yOffset을 뺀 위치로 조정
        v.frame.origin.y = view.frame.height - tabBarHeight - yOffset
        
        self.view.addSubview(v)
        
        UIView.animate(withDuration: 0.7, delay: 1, options: .curveEaseOut, animations: {
            v.alpha = 0.0
        }, completion: { (isCompleted) in
            v.removeFromSuperview()
        })
    }
    
    /// 기본 확인창만 있는 알람창
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


