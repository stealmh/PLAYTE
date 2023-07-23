//
//  LineFooter.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/23.
//

import UIKit
import SnapKit

final class LineFooter: UICollectionReusableView {
    static let identifier = "LineFooter"
    private let lineBackground: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.lineColor?.cgColor
        v.layer.borderWidth = 1
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(lineBackground)
        
        lineBackground.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.top.equalTo(self.snp.bottom).offset(10)
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
struct ForLineFooter: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        LineFooter()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct LineFooter_Preview: PreviewProvider {
    static var previews: some View {
        ForLineFooter()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
