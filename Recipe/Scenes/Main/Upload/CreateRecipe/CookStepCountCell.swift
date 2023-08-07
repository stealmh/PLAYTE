//
//  CookStepCountCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/21.
//

import UIKit
import SnapKit

final class CookStepCountCell: UICollectionReusableView {
    static let identifier = "CookStepCountCell"
    private let label = UILabel()
    private let countLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(label, countLabel)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "hello"
        countLabel.text = "0"
        configureTitleCount(text: "조리 단계", count: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func highlightTextColor() {
        label.asColor(targetString: "분", color: .gray)
    }
    
    func configureTitleCount(text: String, count: Int) {
        label.text = text
        countLabel.text = "\(count)"
//        label.backgroundColor = .red
        countLabel.textColor = count > 0 ? .mainColor : .gray
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(70)
            $0.bottom.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(label)
            $0.left.equalTo(label.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI
struct ForCookStepCountCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CookStepCountCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CookStepCountCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCookStepCountCell()
            .previewLayout(.fixed(width: 393, height: 400))
        //        .padding(10)
    }
}
#endif
