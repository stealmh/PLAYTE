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
    var ingredient: UploadRecipeIngredient = UploadRecipeIngredient(ingredient_id: 0, ingredient_size: 0)
    
    init(item: IngredientInfo) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if item.ingredient_unit == "PIECE" {
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
        if item.ingredient_unit == "PIECE" {
            gramView.configure(item)
        } else {
            defaultView.configure(item)
        }
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        if item.ingredient_type == "INGREDIENTS" {
//            gramView.configure(item)
//        } else {
//            defaultView.configure(item)
//        }
//    }
}

extension AddIngredientViewController: AddIngredientCountViewDelegate {
    func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    func didTappedOkButton(_ count: Int) {
        print(item)
        if item.ingredient_unit == "PIECE" {
            print("== if 문입니다 ==")
            self.forTag = "\(item.ingredient_name) \(count)개"
            self.ingredient = UploadRecipeIngredient(ingredient_id: item.ingredient_id, ingredient_size: count)
            print(self.forTag)
            print(self.ingredient)
        } else {
            print("== else 문입니다 ==")
            var type: String = ""
            switch item.ingredient_unit {
            case "ML":
                type = "mL"
            case "G":
                type = "g"
            case "T":
                type = "T"
            default: return
                
            }
            self.forTag = "\(item.ingredient_name) \(defaultView.count)\(type)"
            self.ingredient = UploadRecipeIngredient(ingredient_id: item.ingredient_id, ingredient_size: defaultView.count)
        }
        didSendEventClosure?(.okButtonTapped)
        dismiss(animated: true)
    }
}

