//
//  BaseViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    deinit {
        print("🍏\(String(describing: Self.self)) deinit.")
    }

}
