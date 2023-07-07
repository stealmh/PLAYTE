//
//  DefaultHeader.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit

final class DefaultHeader: UICollectionReusableView {
    static let identifier = "DefaultHeader"
    private let label = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "hello"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureTitle(text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForDefaultHeaderCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        DefaultHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct DefaultHeaderPreview: PreviewProvider {
    static var previews: some View {
        ForDefaultHeaderCell()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
