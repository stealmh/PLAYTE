//
//  CreateReviewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/31.
//

import UIKit
import SnapKit

protocol CreateReviewControllerDelegate: AnyObject {
    func endFlow()
}
class CreateReviewController: BaseViewController {

    
    var didSendEventClosure: ((CreateReviewController.Event) -> Void)?
    
    enum Event {
        case dismiss
    }
    
    private let createReviewView = CreateReviewView()
    weak var delegate: CreateReviewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .orange
        view.addSubview(createReviewView)
        createReviewView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        createReviewView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        createReviewView.delegate = nil
    }
}

extension CreateReviewController: CreateReviewViewDelegate {
    func didTapRegisterButton() {
        print("CreateReviewController")
        delegate?.endFlow()
//        self.dismiss(animated: true)
//        didSendEventClosure?(.dismiss)
    }
}

