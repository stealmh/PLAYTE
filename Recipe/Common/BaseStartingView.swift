//
//  BaseStartingView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/10.
//

import UIKit
import SnapKit

final class BaseStartingView: UIView {
    
    let appLabel: UILabel = {
        let v = UILabel()
        v.text = "RE:cipe"
        v.font = .boldSystemFont(ofSize: 64)
        v.textColor = .black
        return v
    }()
    
    let subLabel: UILabel = {
        let v = UILabel()
        v.text = "당신을 위한 레시피 제공 서비스"
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews(appLabel, subLabel)
        
        appLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(319)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(appLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
