//
//  CreateShortFormVideoHeaderCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit
import SnapKit

protocol CreateShortFormVideoHeaderCellDelegate: AnyObject {
    func getVideo()
}

class CreateShortFormVideoHeaderCell: UICollectionViewCell {
    
    /// UI Properties
    private let coverModifyBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .grayScale6?.withAlphaComponent(0.8)
        v.layer.cornerRadius = 17
        return v
    }()
    private let coverModifyButton: UIButton = {
        let v = UIButton()
        v.setTitle("커버 편집", for: .normal)
        
        return v
    }()
    
    /// Properties
    weak var delegate: CreateShortFormVideoHeaderCellDelegate?
    
    /// Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        coverModifyBackground.addSubview(coverModifyButton)
        addSubview(coverModifyBackground)
        configureLayout()
        backgroundColor = .gray.withAlphaComponent(0.2)
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateShortFormVideoHeaderCell {
    func configureLayout() {
        coverModifyBackground.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(35)
        }
        
        coverModifyButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

import SwiftUI
struct ForCreateShortFormVideoHeaderCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CreateShortFormVideoHeaderCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateShortFormVideoHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateShortFormVideoHeaderCell()
    }
}
