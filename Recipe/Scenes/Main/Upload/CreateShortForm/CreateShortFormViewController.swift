//
//  CreateShortFormViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class CreateShortFormViewController: BaseViewController {

    
    private let createShortFormView = CreateShortFormView()
    private var disposeBag = DisposeBag()
    var didSendEventClosure: ((CreateShortFormViewController.Event) -> Void)?
    var activeTextField: UITextField?
    enum Event {
        case registerButtonTapped
        ///Todo: createShortFormButtonTapped 로직 연결하기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        bind()
        setNavigationTitle("나의 레시피 작성")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    
}
//MARK: - Method(Normal)
extension CreateShortFormViewController {
    private func addView() {
        view.addSubViews(createShortFormView)
    }
    
    private func configureLayout() {
        createShortFormView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - Method(Rx bind)
extension CreateShortFormViewController {
    func bind() {
        
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct CreateShortFormViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CreateShortFormViewController())
            .toPreview()
    }
}
