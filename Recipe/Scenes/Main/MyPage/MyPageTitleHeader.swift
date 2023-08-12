//
//  MyPageTitleHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/11.
//

import UIKit
import SnapKit

final class MyPageTitleHeader: UICollectionReusableView {
    static let identifier = "MyPageTitleHeader"
    private let label = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(label)
        label.textColor = .grayScale6
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "최근에 시청한 숏폼"
        
        label.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
    
    func configure(_ text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForMyPageTitleHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MyPageTitleHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct MyPageTitleHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForMyPageTitleHeader()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
