//
//  ShortFormSearchCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit

struct ShortFormSearch: Hashable {
    let id = UUID()
    let nickName: String
    let video: String
    let contents: String
    let playTime: String
    let thumnail: UIImage
}

class ShortFormSearchCell: UICollectionViewCell {
    
    private let thumnailImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    private let timeBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 12
        v.backgroundColor = .grayScale6
        return v
    }()
    private let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = .white
        return v
    }()
    
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .white
        return v
    }()
    
    private let contentsLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.maskedCorners = CACornerMask(rawValue: 8)
        addView()
        configureLayout()
        mockData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShortFormSearchCell {
    func addView() {
        timeBackground.addSubview(timeLabel)
        thumnailImageView.addSubViews(timeBackground, timeLabel, nickNameLabel, contentsLabel)
        addSubview(thumnailImageView)
    }
    
    func configureLayout() {
        backgroundColor = .blue.withAlphaComponent(0.5)
        
        thumnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        timeBackground.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
            $0.width.equalTo(52)
            $0.height.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints {
            $0.center.equalTo(timeBackground)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.left.right.equalTo(contentsLabel)
            $0.bottom.equalTo(contentsLabel.snp.top).offset(-5)
        }
    
        contentsLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    func mockData() {
        timeLabel.text = "02:31"
        nickNameLabel.text = "qqkwe123"
        contentsLabel.text = "토마토를 더 맛있게 먹는법"
    }
    
    func configure(_ item: ShortFormSearch) {
        timeLabel.text = item.playTime
        nickNameLabel.text = item.nickName
        contentsLabel.text = item.contents
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormSearchCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormSearchCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ShortFormSearchCell_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormSearchCell()
            .previewLayout(.fixed(width: 167, height: 300))
    }
}
#endif
