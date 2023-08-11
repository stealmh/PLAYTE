//
//  GoViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MypageViewController: BaseViewController {
    
    var didSendEventClosure: ((MypageViewController.Event) -> Void)?
    var disposeBag = DisposeBag()
    private var myPageView = MyPageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myPageView)
        configureLayout()
        configureNavigationTabBar()
    }
    
    enum Event {
        case go
    }
    
    @objc func settingButtonTapped() {
        ///Todo: 세팅눌렀을 때 
    }
}

extension MypageViewController {
    
    private func configureLayout() {
        myPageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationTabBar() {
//        let img = UIImage(named: "setting_svg")!
        let settingButton = UIBarButtonItem(image: UIImage(named: "setting_svg"), style: .done, target: self, action: #selector(settingButtonTapped))
        settingButton.tintColor = .grayScale4!
        navigationItem.rightBarButtonItem = settingButton
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "mypage", size: CGSize(width: 120, height: 38))
        navigationController?.navigationBar.barTintColor = .white
    }
}
