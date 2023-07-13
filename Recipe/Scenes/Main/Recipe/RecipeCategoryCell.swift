//
//  RecipeCategoryCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import SnapKit

final class RecipeCategoryCell: UICollectionViewCell {
    
    private let background: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.backgroundColor = .red.withAlphaComponent(0.1)
        v.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "소중한 사람을 위해"
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubViews(background,titleLabel)
        
        configureLayout()
        configureData(text: "소중한 사람을 위해", color: UIColor.red)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeCategoryCell {
    func configureLayout() {
        background.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(background)
            $0.left.equalTo(background).inset(20)
        }
    }
    
    func configureData(text: String, color: UIColor) {
        background.backgroundColor = color.withAlphaComponent(0.1)
        background.layer.borderColor = color.withAlphaComponent(0.5).cgColor
        titleLabel.text = text
    }
}

#if DEBUG
import SwiftUI
struct ForRecipeCategoryCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeCategoryCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForRecipeCategoryCell_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeCategoryCell()
            .previewLayout(.fixed(width: 174.5, height: 81))
    }
}
#endif
