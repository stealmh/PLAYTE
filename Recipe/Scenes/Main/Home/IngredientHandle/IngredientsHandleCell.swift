//
//  IngredientsHandleCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit

class IngredientsHandleCell: UICollectionViewCell {
    
    private let ingredientImageView = UIImageView()
    private let ingredientTitle = UILabel()
    private let ingredientSubTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubViews(ingredientImageView,
                    ingredientTitle,
                    ingredientSubTitle)
        
        self.setUI()
        configure(IngredientsHandle(image: UIImage(named: "popcat")!, title: "식빵은 2~3일이 지나면 냉동보관!", contents: "먹고 싶을 땐 미리 꺼내서 실온 해동해주세요."))

    }
    
    func configure(_ data: IngredientsHandle) {
        ingredientImageView.image = data.image
        ingredientTitle.text = data.title
        ingredientSubTitle.text = data.contents
        
        ingredientTitle.font = .boldSystemFont(ofSize: 15)
        ingredientSubTitle.font = .systemFont(ofSize: 13)
    }
    
    func setUI() {
        ingredientImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.width.equalToSuperview().dividedBy(8)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        ingredientTitle.snp.makeConstraints {
            $0.top.equalTo(ingredientImageView)
            $0.left.equalTo(ingredientImageView.snp.right).offset(10)
        }
        
        ingredientSubTitle.snp.makeConstraints {
            $0.top.equalTo(ingredientTitle.snp.bottom)
            $0.left.equalTo(ingredientImageView.snp.right).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#if DEBUG
import SwiftUI
struct ForIngredientsHandleCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        IngredientsHandleCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct IngredientsHandleCellPreview: PreviewProvider {
    static var previews: some View {
        ForIngredientsHandleCell()
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
#endif
