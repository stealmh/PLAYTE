//
//  CookStepHeaderView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/21.
//

import UIKit
import SnapKit

final class CookStepHeaderView: UICollectionReusableView {
    static let identifier = "CookStepHeaderView"
    private let label = UILabel()
    private let label2 = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(label, label2)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "hello"
        label2.text = "hello"
        label2.font = .boldSystemFont(ofSize: 17)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureDoubleTitle(text: String, text2: String) {
        label.text = text
        label2.text = text2
        label2.font = .boldSystemFont(ofSize: 17)
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
        
        label2.snp.makeConstraints {
            $0.bottom.equalTo(label)
            $0.left.equalTo(self.snp.centerX).offset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForCookStepHeaderView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CookStepHeaderView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CookStepHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        ForCookStepHeaderView()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
