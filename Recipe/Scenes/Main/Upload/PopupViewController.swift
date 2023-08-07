//
//  PopupViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/13.
//

import UIKit
import SnapKit

class PopupViewController: BaseViewController, PopupViewDelegate {
    var didSendEventClosure: ((PopupViewController.Event) -> Void)?
    
    enum Event {
        case showCreateRecipeView
        ///Todo: createShortFormButtonTapped 로직 연결하기
    }
    
    func createRecipeButtonTapped() {
        didSendEventClosure?(.showCreateRecipeView)
    }
    
    func createShortFormButtonTapped() {
        print("short tapped")
    }
    
    ///UI Properties
    private let popupView = PopupView()

    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(popupView)
        popupView.delegate = self
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        popupView.delegate = nil
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        popupView.delegate = self
    }

}
