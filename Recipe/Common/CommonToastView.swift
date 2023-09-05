//
//  CommonToastView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/22.
//

import UIKit
import SnapKit

class CommonToastView: UIView {
    
    private let toastLabel: UILabel = {
        let v = UILabel()
        v.text = "??"
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .mainColor
        return v
    }()
    
    private let deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "toastButton_svg"), for: .normal)
        v.tintColor = .mainColor
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(toastLabel, deleteButton)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainColor?.cgColor
        backgroundColor = .sub1
        
        toastLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
            $0.left.equalToSuperview().inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.height.equalTo(toastLabel)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(14)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureText(_ text: String) {
        toastLabel.text = text
    }
}
