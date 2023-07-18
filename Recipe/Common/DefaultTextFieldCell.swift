//
//  DefaultTextFieldCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class DefaultTextFieldCell: UICollectionViewCell {
    
    ///UI Properties
    private let recipeNametextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "placeholder"
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension DefaultTextFieldCell {
    
    private func addViews() {
        addSubViews(recipeNametextField)
    }
    
    private func setupView() {
        recipeNametextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(text: String) {
        recipeNametextField.placeholder = text
    }
}

//MARK: - Method(Rx Bind)
extension DefaultTextFieldCell {
    func bind() {

    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForDefaultTextFieldCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        DefaultTextFieldCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct DefaultTextFieldCell_Preview: PreviewProvider {
    static var previews: some View {
        ForDefaultTextFieldCell()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
