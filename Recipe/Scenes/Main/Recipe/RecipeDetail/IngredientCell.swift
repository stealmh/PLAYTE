//
//  IngredientCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import SnapKit

struct DetailIngredient: Hashable {
    let id = UUID()
    let ingredientTitle: String
    let ingredientCount: String
    let seasoningTitle: String
    let seasoningCount: String
    
}

final class IngredientCell: UICollectionViewCell {
    
    private let ingredientLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let ingredientCount: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .mainColor
        v.textAlignment = .right
        return v
    }()
    
    private let seasoningLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let seasoningCount: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .mainColor
        v.textAlignment = .right
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        mockConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension IngredientCell {
    func addView() {
        self.addSubViews(ingredientLabel, ingredientCount, seasoningLabel, seasoningCount)
    }
    func configureLayout() {
//        ingredientLabel.backgroundColor = .green
        ingredientLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(14)
        }
        
//        ingredientCount.backgroundColor = .red
        ingredientCount.snp.makeConstraints {
            $0.top.equalTo(ingredientLabel)
            $0.right.equalTo(ingredientLabel).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(ingredientLabel)
        }
        
//        seasoningLabel.backgroundColor = .red
        seasoningLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(self.snp.centerX).offset(30)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(14)
        }
//        seasoningCount.backgroundColor = .blue
        seasoningCount.snp.makeConstraints {
            $0.top.equalTo(seasoningLabel)
            $0.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(seasoningLabel)
        }
    }
    
    //for data inject
    func configure(_ item: DetailIngredient) {
        ingredientLabel.text = item.ingredientTitle
        ingredientCount.text = item.ingredientCount
        seasoningLabel.text = item.seasoningTitle
        seasoningCount.text = item.seasoningCount
    }
    
    func mockConfigure() {
        ingredientLabel.text = "토마토"
        ingredientCount.text = "2개"
        
        seasoningLabel.text = "굴소스"
        seasoningCount.text = "2T"
    }
}

//MARK: - Method(Rx bind)
extension IngredientCell {
    func bind() {}
}

#if DEBUG
import SwiftUI
struct ForIngredientCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        IngredientCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct IngredientCell_Preview: PreviewProvider {
    static var previews: some View {
        ForIngredientCell()
            .previewLayout(.fixed(width: 380, height: 80))
    }
}
#endif
