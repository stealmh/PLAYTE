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
    private let newFilterButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .red
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(newFilterButton)
        newFilterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
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
