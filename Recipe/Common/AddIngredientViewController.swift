//
//  AddIngredientViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit

class AddIngredientViewController: UIViewController {
    
    /*
     gram
     개수
     ml
     T
     */
    
    private let gramView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(gramView)
        view.backgroundColor = .grayScale6?.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
        
        gramView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }

}
