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
        case showCreateShortFormView
    }
    
    func createRecipeButtonTapped() {
        didSendEventClosure?(.showCreateRecipeView)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func createShortFormButtonTapped() {
        didSendEventClosure?(.showCreateShortFormView)
        self.tabBarController?.tabBar.isHidden = true
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
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .black)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        popupView.delegate = nil
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        popupView.delegate = self
    }

}
