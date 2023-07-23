//
//  Template.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

//MARK: - UICollectionViewCell Templete
import UIKit
import SnapKit

final class ForCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension ForCell {
    func addView() {}
    func configureLayout() {}
    func configure() {} //for data inject
}

//MARK: - Method(Rx bind)
extension ForCell {
    func bind() {}
}

#if DEBUG
import SwiftUI
struct ForCellRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ForCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct a_Preview: PreviewProvider {
    static var previews: some View {
        ForCellRepresentable()
            .previewLayout(.fixed(width: 380, height: 80))
    }
}
#endif
