//
//  RecipeCategoryHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
/// Todo: UIView에 반원 얹기

import UIKit
import SnapKit

final class DefaultRecipeCategoryView: UICollectionViewCell {
    
    let backgroundButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "a_svg"), for: .normal)
        return v
    }()
    
    private let buttonTitle: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(buttonTitle)
        contentView.addSubview(backgroundButton)
        configureLayout()
        clipsToBounds = true
    }
    
    init(text: String, img: UIImage) {
        super.init(frame: .zero)
        buttonTitle.text = text
        backgroundButton.setImage(img, for: .normal)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

//MARK: - Method(Normal)
extension DefaultRecipeCategoryView {
    func configureLayout() {
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonTitle.snp.makeConstraints {
            $0.centerY.equalTo(backgroundButton)
            $0.left.equalTo(backgroundButton).inset(15)
        }
    }
    
    func configureData(_ item: MockCategoryData) {
        buttonTitle.text = item.text
        backgroundButton.setImage(item.img, for: .normal)
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
            .previewLayout(.fixed(width: 174, height: 80))
    }
}
#endif
