//
//  MyCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/05.
//

import UIKit
import SnapKit

final class MyCell: UITableViewCell {

    private let myLabel: UILabel = {
        let v = UILabel()
        v.text = "hello~"
        return v
    }()
    
    private let ingredientSepearate: UILabel = {
        let v = UILabel()
        v.text = "신선 식품"
        v.textColor = .gray
        v.textAlignment = .right
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews(myLabel,ingredientSepearate)
        backgroundColor = .gray.withAlphaComponent(0.2)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        myLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
            $0.right.equalTo(self.snp.centerX)
        }
        
        ingredientSepearate.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(self.snp.centerX)
        }
    }
    
    func setData(text: String) {
        myLabel.text = text
    }

}

#if DEBUG
import SwiftUI
struct ForMyCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MyCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct MyCellPreview: PreviewProvider {
    static var previews: some View {
        ForMyCell()
            .previewLayout(.fixed(width: 393, height: 30))
    }
}
#endif
