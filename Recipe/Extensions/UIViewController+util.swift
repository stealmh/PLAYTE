//
//  UIViewController+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SwiftUI

#if DEBUG
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
    
    func showToastTest(message : String,
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
        UIView.animate(withDuration: .infinity, delay: 1, options: .curveEaseOut, animations: {
                 v.alpha = 0.0
            //아래쪽으로 사라지게 하기 위함
            let scale = CGAffineTransform(translationX: 0, y: 200)
            v.transform = scale
            }, completion: {(isCompleted) in
                v.removeFromSuperview()
            })
        }
    /// Navigation의 BackButton의 Label을 지우고 "<" 의 색깔을 지정할 수 있습니다.
    func defaultNavigationBackButton(backButtonColor: UIColor) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = backButtonColor
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

}
#endif


