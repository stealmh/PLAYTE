//
//  RecipeHeaderCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class RecipeHeaderCell: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    private let recentBackground = RecipeDefaultTagView()
    private let recentButton = RecipeDefaultTagButton()
    
    private let popularBackground = RecipeDefaultTagView()
    private let popularButton = RecipeDefaultTagButton()
    
    private let IngredientBackground = RecipeDefaultTagView()
    private let IngredientButton = RecipeDefaultTagButton()
    
    private let minimumBackground = RecipeDefaultTagView()
    private let minimumButton = RecipeDefaultTagButton()

    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(recentBackground, recentButton)
        
        recentBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        recentButton.snp.makeConstraints {
            $0.center.equalTo(recentBackground)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


}

import SwiftUI
@available(iOS 13.0, *)
struct RecipeView1_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeView()
    }
}
