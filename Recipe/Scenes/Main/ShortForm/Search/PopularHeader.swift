//
//  PopularHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit

class PopularHeader: UICollectionReusableView {
    
    private let recentSearchTitle: UILabel = {
        let v = UILabel()
        v.text = "인기 검색어"
        v.textColor = .black
        v.font = .boldSystemFont(ofSize: 18)
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(recentSearchTitle)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension PopularHeader {
    func configureLayout() {
        recentSearchTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
            $0.height.equalTo(17)
            $0.width.equalToSuperview().dividedBy(2)
        }
    }
}
