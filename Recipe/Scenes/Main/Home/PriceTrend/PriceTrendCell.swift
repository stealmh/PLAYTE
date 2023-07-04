//
//  MulgaCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class PriceTrendCell: UICollectionViewCell {
    
    let ingredientsTitle: UILabel = {
        let v = UILabel()
        return v
    }()
    
    let ingredientsTransitionLabel: UILabel = {
        let v = UILabel()
        return v
    }()
    
    let ingredientsCountLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        return v
    }()
    
    let ingredientsPriceLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        return v
    }()
    
    let divideLine: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        addSubViews(ingredientsTitle,
                    ingredientsTransitionLabel,
                    ingredientsCountLabel,
                    ingredientsPriceLabel,
                    divideLine)
        
        self.setUI()
        configure(ingredients: PriceTrend(title: "계란",
                                           transition: "+8원(0.4%)",
                                           count: 1,
                                           price: 214))
    }
    
    func configure(ingredients: PriceTrend) {
        ingredientsTitle.text = ingredients.title
        ingredientsTransitionLabel.text = ingredients.transition
        ingredientsCountLabel.text = "\(ingredients.count)개"
        ingredientsPriceLabel.text = "\(ingredients.price)원"
    }
    
    func setUI() {
        ingredientsTitle.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(10)
            $0.width.equalToSuperview()
        }
        ingredientsTransitionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(ingredientsTitle.snp.bottom).offset(5)
            $0.width.equalToSuperview()
        }
        divideLine.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(ingredientsTransitionLabel.snp.bottom).offset(10)
            $0.height.equalTo(2)
        }
        
        ingredientsCountLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(divideLine.snp.bottom).offset(5)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        ingredientsPriceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(divideLine.snp.bottom).offset(5)
            $0.width.equalToSuperview().dividedBy(2)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


#if DEBUG
import SwiftUI
struct ForPriceTrendCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        PriceTrendCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PriceTrendCellPreview: PreviewProvider {
    static var previews: some View {
        ForPriceTrendCell()
            .previewLayout(.fixed(width: 150, height: 100))
        //        .padding(10)
    }
}
#endif
