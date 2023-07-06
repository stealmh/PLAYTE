//
//  SplashViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit

class SplashViewController: BaseViewController {

    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    private let testLabel: UILabel = {
        let v = UILabel()
        v.text = "Splash View"
        v.font = .boldSystemFont(ofSize: 50)
        v.textColor = .red
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.didSendEventClosure?(.endSplash)
        }
        
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

    }
}

extension SplashViewController {
    enum Event {
        case endSplash
    }
}
