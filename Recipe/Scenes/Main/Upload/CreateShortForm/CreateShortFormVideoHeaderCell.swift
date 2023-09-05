//
//  CreateShortFormVideoHeaderCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit
import SnapKit

protocol CreateShortFormVideoHeaderCellDelegate: AnyObject {
    func getVideo()
}

class CreateShortFormVideoHeaderCell: UICollectionViewCell {
    
    /// UI Properties
    let thumbnailImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.borderColor = UIColor.grayScale3?.cgColor
        v.layer.borderWidth = 1
        v.clipsToBounds = true
        return v
    }()
    private let coverModifyBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 12
        v.backgroundColor = .grayScale6?.withAlphaComponent(0.8)
        return v
    }()
    
    let addVideoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "youtube_svg"), for: .normal)
        return v
    }()
    
    private let addVideoGuideLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        v.textAlignment = .center
        v.text = "영상을 선택해주세요"
        return v
    }()
    
    let coverModifyButton: UIButton = {
        let v = UIButton()
        v.setTitle("수정", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 12)
        return v
    }()
    
    /// Properties
    weak var delegate: CreateShortFormVideoHeaderCellDelegate?
    
    /// Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(addVideoGuideLabel, thumbnailImageView)
        contentView.addSubview(addVideoButton)
        contentView.addSubview(coverModifyBackground)
        coverModifyBackground.addSubview(coverModifyButton)
        configureLayout()
        layer.cornerRadius = 10
        layer.borderColor = UIColor.grayScale3?.cgColor
        layer.borderWidth = 1
        noVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateShortFormVideoHeaderCell {
    func configureLayout() {
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverModifyBackground.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(20)
            $0.width.equalTo(41)
            $0.height.equalTo(24)
        }
        
        addVideoButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        coverModifyButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addVideoGuideLabel.snp.makeConstraints {
            $0.top.equalTo(addVideoButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    func hasVideo() {
        coverModifyBackground.isHidden = false
        addVideoButton.isHidden = true
        addVideoGuideLabel.isHidden = true
    }
    func noVideo() {
        coverModifyBackground.isHidden = true
        addVideoButton.isHidden = false
        addVideoGuideLabel.isHidden = false
    }
}

import SwiftUI
struct ForCreateShortFormVideoHeaderCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CreateShortFormVideoHeaderCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateShortFormVideoHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateShortFormVideoHeaderCell()
            .previewLayout(.fixed(width: 202.5, height: 360))
    }
}
