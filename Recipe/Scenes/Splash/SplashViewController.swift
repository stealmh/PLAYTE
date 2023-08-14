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
    private let baseView: BaseStartingView = {
        let v = BaseStartingView()
        /// Todo: hexCode -> enum
        v.appLabel.asColor(targetString: "RE", color: UIColor.hexStringToUIColor(hex: "#FF5520"))
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(baseView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            LoginService.shared.appleLogin(accessToken: KeyChain.shared.read(account: .accessToken))
            self.didSendEventClosure?(.endSplash)
        }
        
        baseView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
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
