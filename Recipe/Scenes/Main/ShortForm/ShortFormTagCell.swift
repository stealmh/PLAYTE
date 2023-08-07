//
//  ShortFormTagCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit

final class ShortFormTagCell: UICollectionViewCell {
    static let identifier = "ShortFormTagCell"

    private let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor?.withAlphaComponent(0.3)
        v.layer.borderColor = UIColor.mainColor?.cgColor
        v.layer.borderWidth = 1
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 15
        return v
    }()
    
    private let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        v.sizeToFit()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagBackground.addSubview(tagLabel)
        contentView.addSubview(tagBackground)
//        tagBackground.layer.masksToBounds = true
//        tagBackground.layer.cornerRadius = 21.67
        setConstant()
        configure(Tag(name: "샤인머스켓"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstant() {
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        tagBackground.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.greaterThanOrEqualTo(tagLabel).offset(35)
        }
    }
    
    func configure(_ item: Tag) {
        tagLabel.text = item.name
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormTagCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        ShortFormTagCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ShortFormTagCellPreview: PreviewProvider {
    static var previews: some View {
        ForShortFormTagCell()
        .previewLayout(.fixed(width: 100, height: 60))
    }
}
#endif
