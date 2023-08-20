//
//  AddIngredientViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit

class AddIngredientViewController: BaseViewController {
    /*
     gram
     개수
     ml
     T
     */
    var didSendEventClosure: ((AddIngredientViewController.Event) -> Void)?
    var item: IngredientInfo?
    enum Event {
        case cancelButtonTapped
        case okButtonTapped
    }
    
    
    private let gramView = AddIngredientCountView()
    var forTag: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(gramView)
        view.backgroundColor = .grayScale6?.withAlphaComponent(0.5)
        gramView.delegate = self
        
        gramView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327)
            $0.height.equalTo(205)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        guard let item else { return }
        gramView.configure(item)
    }
}

extension AddIngredientViewController: AddIngredientCountViewDelegate {
    func didTappedCancelButton() {
//        gramView.
        guard let item else { return }
        print(item.ingredient_id)
        print(gramView.count)
        dismiss(animated: true)
    }
    
    func didTappedOkButton(_ count: Int) {
        guard let item else { return }
        self.forTag = "\(item.ingredient_name) \(gramView.count)개"
        didSendEventClosure?(.okButtonTapped)
        dismiss(animated: true)
    }
}


