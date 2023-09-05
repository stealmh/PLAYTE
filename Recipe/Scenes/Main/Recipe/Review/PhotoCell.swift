//
//  PhotoCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import SnapKit

class PhotoCell: UICollectionViewCell {
    
    private let photoImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        self.addSubview(photoImageView)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ item: Photo) {
        DispatchQueue.main.async {
            self.photoImageView.backgroundColor = .grayScale3
            self.photoImageView.loadImage(from: item.image)
        }
    }
}
