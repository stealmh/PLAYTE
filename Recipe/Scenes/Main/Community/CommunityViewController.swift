//
//  CommunityViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CommunityViewController: BaseViewController {
    
    var didSendEventClosure: ((CommunityViewController.Event) -> Void)?
    var disposeBag = DisposeBag()
    
    private let button: UIButton = {
        let v = UIButton()
        v.setTitle("로그아웃", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.rx.tap
            .subscribe(onNext: { _ in
                print("tapped")
                self.didSendEventClosure?(.go)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        disposeBag = DisposeBag()
    }
    
    enum Event {
        case go
    }
}

