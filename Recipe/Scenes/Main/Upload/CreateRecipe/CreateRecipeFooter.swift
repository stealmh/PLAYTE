//
//  CreateRecipeFooter.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CreateRecipeFooter: UICollectionReusableView {
    static let identifier = "CreateRecipeFooter"
    ///UI Properties
    let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("등록", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 5
        v.backgroundColor = .mainColor
        v.isHidden = true
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddView()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method
extension CreateRecipeFooter {
    private func setAddView() {
        addSubview(registerButton)
    }
    
    private func configureLayout() {
        registerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        
    }
    
    func configure(_ text: String) {
        registerButton.setTitle(text, for: .normal)
    }
}
