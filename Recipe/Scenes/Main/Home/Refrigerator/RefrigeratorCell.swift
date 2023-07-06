//
//  RefrigeratorCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class RefrigeratorCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    private var refrigeratorBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .gray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews(refrigeratorBackground)
        setUI()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {

        refrigeratorBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.5)
            $0.height.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: Refrigerator) {
        let view = data.view
        view.layer.cornerRadius = 30
        addSubview(view)
        view.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(refrigeratorBackground)
        }
    }
    
    
    
    enum Constants {
        
    }
}

#if DEBUG
import SwiftUI
struct ForRefrigeratorCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RefrigeratorCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RefrigeratorCellPreview: PreviewProvider {
    static var previews: some View {
        ForRefrigeratorCell()
            .previewLayout(.fixed(width: 393, height: 400))
    }
}
#endif
