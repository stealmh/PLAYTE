//
//  MyReviewPhotoCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import SnapKit

class MyReviewPhotoCell: UICollectionViewCell {
    
    private let photo: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .grayScale3
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(photo)
        photo.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: String) {
        DispatchQueue.main.async {
            self.photo.loadImage(from: item)
        }
    }
    
}
