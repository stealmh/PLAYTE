//
//  RecipeCategoryHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
/// Todo: UIView에 반원 얹기

import UIKit
import SnapKit

final class DefaultRecipeCategoryView: UICollectionViewCell {
    
    private let background: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.backgroundColor = .green.withAlphaComponent(0.1)
        v.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "다이어터를\n위한 레시피"
        v.numberOfLines = 2
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    private let circleBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .sub3
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 5
        v.layer.cornerRadius = 20
        return v
    }()
    
    private let img: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "diet_svg")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        addSubViews(background, titleLabel)
        contentView.addSubview(circleBackground)
        contentView.addSubview(img)
        configureLayout()
    }
    
    init(text: String, color: UIColor, img: UIImage) {
        super.init(frame: .zero)
        titleLabel.text = text
        self.img.image = img
        background.backgroundColor = color.withAlphaComponent(0.3)
        background.layer.borderColor = color.withAlphaComponent(0.5).cgColor
        addSubViews(background, titleLabel, circleBackground, self.img)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleBackground.layer.cornerRadius = circleBackground.frame.width / 2
    }
}

//MARK: - Method(Normal)
extension DefaultRecipeCategoryView {
    func configureLayout() {
        
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        
        circleBackground.snp.makeConstraints {
            $0.width.equalTo(background).dividedBy(2)
            $0.height.equalTo(110)
            $0.centerY.equalTo(background)
            $0.right.equalTo(background)
        }
        
        img.snp.makeConstraints {
            $0.height.width.equalTo(70)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(5)
        }
    }
    
    func configure(text: String, color: UIColor, img: UIImage) {
        titleLabel.text = text
        self.img.image = img
        background.backgroundColor = color.withAlphaComponent(0.3)
        background.layer.borderColor = color.withAlphaComponent(0.5).cgColor
        addSubViews(background, titleLabel, circleBackground, self.img)
        configureLayout()
    }
}

#if DEBUG
import SwiftUI
struct ForDefaultRecipeCategoryView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        DefaultRecipeCategoryView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForDefaultRecipeCategoryView_Preview: PreviewProvider {
    static var previews: some View {
        ForDefaultRecipeCategoryView()
            .previewLayout(.fixed(width: 200, height: 81))
    }
}
#endif
