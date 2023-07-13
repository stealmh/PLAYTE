//
//  PopupViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/13.
//

import UIKit
import SnapKit

class PopupViewController: UIViewController {
    
    ///UI Properties
    private let popupView = PopupView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        popupView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapView() {
        self.dismiss(animated: false)
    }

}
