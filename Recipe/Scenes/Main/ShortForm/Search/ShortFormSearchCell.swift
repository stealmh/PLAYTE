//
//  ShortFormSearchCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit

class ShortFormSearchCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormSearchCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormSearchCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ShortFormSearchCell_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormSearchCell()
            .previewLayout(.fixed(width: 167, height: 300))
    }
}
#endif
