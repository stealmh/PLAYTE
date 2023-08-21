//
//  AddIngredientViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit

class AddIngredientViewController: BaseViewController {
    var didSendEventClosure: ((AddIngredientViewController.Event) -> Void)?
    var item: IngredientInfo
    enum Event {
        case cancelButtonTapped
        case okButtonTapped
    }
    
    private let gramView = AddIngredientCountView()
    private let defaultView = AddIngredientDefaultView()
    
    var forTag: String = ""
    
    init(item: IngredientInfo) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item.ingredient_type == "PIECES" {
            view.addSubview(gramView)
            view.backgroundColor = .grayScale6?.withAlphaComponent(0.5)
            gramView.delegate = self
            
            gramView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(327)
                $0.height.equalTo(205)
            }
        } else {
            view.addSubview(defaultView)
            view.backgroundColor = .grayScale6?.withAlphaComponent(0.5)
            defaultView.delegate = self
            
            defaultView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(327)
                $0.height.equalTo(205)
            }
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if item.ingredient_type == "PIECES" {
            gramView.configure(item)
        } else {
            defaultView.configure(item)
        }
    }
}

extension AddIngredientViewController: AddIngredientCountViewDelegate {
    func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    func didTappedOkButton(_ count: Int) {
        if item.ingredient_type == "PIECES" {
            self.forTag = "\(item.ingredient_name) \(gramView.count)개"
        } else {
            self.forTag = "\(item.ingredient_name) \(defaultView.count)\(item.ingredient_unit)"
        }
        didSendEventClosure?(.okButtonTapped)
        dismiss(animated: true)
    }
}

