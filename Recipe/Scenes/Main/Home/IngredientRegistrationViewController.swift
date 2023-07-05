//
//  IngredientRegistrationViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/05.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class IngredientRegistrationViewController: BaseViewController {

    private let sheetTitle: UILabel = {
        let v = UILabel()
        v.text = "식재료 등록"
        v.font = .boldSystemFont(ofSize: Constants.titleSize)
        return v
    }()
    
    private let cancelButton: UIButton = {
        let v = UIButton()
        v.setTitle("취소", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        return v
    }()
    
    private let sheetSubTitle: UILabel = {
        let v = UILabel()
        v.text = "재료 이름"
        v.font = .boldSystemFont(ofSize: Constants.subTitleSize)
        return v
    }()
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "재료 이름을 검색해주세요."
        v.layer.cornerRadius = Constants.mediumCorner
        v.clipsToBounds = true
        return v
    }()
    
    private let searchImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "magnifyingglass")!
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let coldRefrigeratorButton: UIButton = {
        let v = UIButton()
        v.setTitle("냉장/냉동", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let normalRefrigeratorButton: UIButton = {
        let v = UIButton()
        v.setTitle("실온", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("등록", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(sheetTitle,
                          cancelButton,
                          sheetSubTitle,
                         searchTextField,
                         coldRefrigeratorButton,
                         normalRefrigeratorButton,
                         registerButton,
                         searchImageView)
        configureLayout()
    }
}

//MARK: - Method(normal)
extension IngredientRegistrationViewController {
    func configureLayout() {
        sheetTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        
        sheetSubTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(sheetTitle.snp.bottom).offset(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(sheetSubTitle.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
        searchImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextField).inset(7)
            $0.width.equalTo(searchTextField.snp.height)
            $0.right.equalTo(searchTextField).inset(10)
        }
        
        coldRefrigeratorButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.right.equalTo(view.snp.centerX).inset(10)
            $0.height.equalTo(searchTextField)
        }
        
        normalRefrigeratorButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.centerX).offset(10)
            $0.height.equalTo(searchTextField)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(normalRefrigeratorButton.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(searchTextField)
        }
    }
}

extension IngredientRegistrationViewController {
    enum Constants {
        static let titleSize: CGFloat = 20
        static let subTitleSize: CGFloat = 18
        static let smallCorner: CGFloat = 5
        static let mediumCorner: CGFloat = 10
    }
}

//MARK: - VC Preview
import SwiftUI
struct IngredientRegistrationViewController_Preview: PreviewProvider {
    static var previews: some View {
        IngredientRegistrationViewController().toPreview()
    }
}
