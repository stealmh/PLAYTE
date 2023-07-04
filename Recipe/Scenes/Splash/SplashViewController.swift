//
//  SplashViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

class SplashViewController: BaseViewController {

    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.didSendEventClosure?(.endSplash)
        }

    }
}

extension SplashViewController {
    enum Event {
        case endSplash
    }
}
