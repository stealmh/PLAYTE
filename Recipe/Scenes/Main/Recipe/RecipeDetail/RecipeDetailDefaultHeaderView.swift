//
//  RecipeDetailDefaultHeaderView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/23.
//

import UIKit
import SnapKit

final class RecipeDetailDefaultHeaderView: UICollectionReusableView {
    static let identifier = "RecipeDetailDefaultHeaderView"
    private let label = UILabel()
    private let lineBackground: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.lineColor?.cgColor
        v.layer.borderWidth = 1
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(label, lineBackground)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "레시피"
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(self.snp.centerX)
        }
        
        lineBackground.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.top.equalTo(label.snp.bottom).offset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForRecipeDetailDefaultHeaderView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailDefaultHeaderView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeDetailDefaultHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailDefaultHeaderView()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
