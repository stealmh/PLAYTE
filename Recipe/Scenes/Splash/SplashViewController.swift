//
//  SplashViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {

    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    
    private let splashImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "splash1")
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashImageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.didSendEventClosure?(.endSplash)
        }
        
        splashImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(239.06)
            $0.height.equalTo(81.57)
            
        }

    }
}

extension SplashViewController {
    enum Event {
        case endSplash
    }
}

//MARK: - VC Preview
import SwiftUI
struct SplashViewController_preview: PreviewProvider {
    static var previews: some View {
        SplashViewController().toPreview()
    }
}
