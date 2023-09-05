//
//  RecentSearchTagCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit

class RecentSearchTagCell: UICollectionViewCell {
    static let identifier = "RecentSearchTagCell"
    
    let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        return v
    }()
    
    let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .mainColor
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(tagBackground)
        addSubview(tagLabel)
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 15
        setConstant()
        layer.masksToBounds = true
        layer.cornerRadius = 15
        backgroundColor = .sub1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setConstant() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true // 최소 높이를 40으로 지정
    }
    
    func configure(_ item: SearchTag) {
        tagLabel.text = item.tag
    }
}



class ShortFormTagCell1: UICollectionViewCell {
    static let identifier = "ShortFormTagCell1"
    
    let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.borderColor = UIColor.mainColor?.cgColor
        v.layer.borderWidth = 1
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 15
        return v
    }()
    
    let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(tagBackground)
        addSubview(tagLabel)
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 15
        setConstant()
        layer.masksToBounds = true
        layer.cornerRadius = 15
        backgroundColor = .mainColor?.withAlphaComponent(0.3)
        
        layer.borderColor = UIColor.mainColor?.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setConstant() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true // 최소 높이를 40으로 지정
    }
    
    func configure(_ item: Tag) {
        tagLabel.text = item.name
    }
}
