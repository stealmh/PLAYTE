//
//  TagCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/05.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        return v
    }()
    
    let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .black
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagBackground)
        contentView.addSubview(tagLabel)
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 30
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 15
        setConstant()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstant() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        tagBackground.translatesAutoresizingMaskIntoConstraints = false
        tagBackground.frame = contentView.frame
    }
    
    func configure(with title: String) {
        tagLabel.text = title
    }
}

#if DEBUG
import SwiftUI
struct ForProfileHeaderCell12: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        TagCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ProfileHeaderPreview12: PreviewProvider {
    static var previews: some View {
        ForProfileHeaderCell12()
        .previewLayout(.fixed(width: 100, height: 60))
        .padding(10)
    }
}
#endif
