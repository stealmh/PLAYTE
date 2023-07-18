//
//  CreateRecipeHeaderView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CreateRecipeHeaderCell: UICollectionViewCell {
    
    ///UI Properties
    private let createRecipeTitle: UILabel = {
        let v = UILabel()
        v.text = "나의 레시피 작성"
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    private let headerBackground = UIView()
    
    ///Properties
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
//MARK: - Method(Normal)
extension CreateRecipeHeaderCell {
    private func addViews() {
        headerBackground.addSubview(createRecipeTitle)
        addSubViews(headerBackground)
    }
    
    private func configureLayout() {
        headerBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createRecipeTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForCreateRecipeHeaderView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CreateRecipeHeaderCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateRecipeHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateRecipeHeaderView()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
