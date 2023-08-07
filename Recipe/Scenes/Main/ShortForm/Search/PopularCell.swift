//
//  PopularCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit

struct PopularRank: Hashable {
    let id = UUID()
    let rank: Int
    let keyword: String
}

class PopularCell: UICollectionViewCell {
    
    private let popularKeywordRank: UILabel = {
        let v = UILabel()
        v.text = "0"
        v.font = .boldSystemFont(ofSize: 16)
        return v
    }()
    private let popularKeywordLabel: UILabel = {
        let v = UILabel()
        v.text = "0"
        v.font = .systemFont(ofSize: 16)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(popularKeywordRank, popularKeywordLabel)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopularCell {
    func configureLayout() {
        popularKeywordRank.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
        
        popularKeywordLabel.snp.makeConstraints {
            $0.top.height.equalTo(popularKeywordRank)
            $0.left.equalTo(popularKeywordRank.snp.right).offset(10)
            $0.right.equalToSuperview()
        }
    }
    
    func configure(_ item: PopularRank) {
        popularKeywordRank.text = "\(item.rank)"
        popularKeywordLabel.text = item.keyword
    }
}
