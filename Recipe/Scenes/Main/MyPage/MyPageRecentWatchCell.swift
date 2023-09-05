//
//  MyPageRecentWatchCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/11.
//

import UIKit
import SnapKit

struct MyPageRecentWatch: Hashable {
    let id = UUID()
    let views: String
    let contents: String
}

class MyPageRecentWatchCell: UICollectionViewCell {
    
    private let thumnailImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    private let contentsLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        v.numberOfLines = 2
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

extension MyPageRecentWatchCell {
    func addView() {
        thumnailImageView.addSubViews(contentsLabel)
        addSubview(thumnailImageView)
    }
    
    func configureLayout() {
        backgroundColor = .grayScale3
        
        thumnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        contentsLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    func mockData() {
        contentsLabel.text = "토마토를 더 맛있게 먹는법"
    }
    
    func configure(_ item: ShortFormInfo) {
        contentsLabel.text = item.shortform_description
        if let videoURL = URL(string: item.video_url) {
            let thumbnail = videoURL.generateThumbnail()
            DispatchQueue.main.async {
                self.thumnailImageView.image = thumbnail
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct ForMyPageRecentWatchCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MyPageRecentWatchCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct MyPageRecentWatchCell_Preview: PreviewProvider {
    static var previews: some View {
        ForMyPageRecentWatchCell()
            .previewLayout(.fixed(width: 99, height: 176))
    }
}
#endif
