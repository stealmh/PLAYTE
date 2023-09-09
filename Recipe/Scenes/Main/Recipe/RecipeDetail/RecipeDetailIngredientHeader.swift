//
//  RecipeDetailIngredientHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import SnapKit

final class RecipeDetailIngredientHeader: UICollectionReusableView {
    static let identifier = "RecipeDetailIngredientHeader"
    private let label = UILabel()
    private let label2 = UILabel()
    private let lineBackground: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.lineColor?.cgColor
        v.layer.borderWidth = 1
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(label, label2, lineBackground)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "재료"
        label2.text = "양념"
        label2.font = .boldSystemFont(ofSize: 18)
        configureDoubleTitle(text: "재료", text2: "양념")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    func configureDoubleTitle(text: String, text2: String) {
        label.text = text
        label2.text = text2
        label2.font = .boldSystemFont(ofSize: 17)
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(self.snp.centerX)
        }
        
        label2.snp.makeConstraints {
            $0.bottom.equalTo(label)
            $0.left.equalTo(self.snp.centerX).offset(10)
            $0.right.equalToSuperview()
        }
        
        lineBackground.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.top.equalTo(label.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForRecipeDetailIngredientHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailIngredientHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeDetailIngredientHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailIngredientHeader()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
