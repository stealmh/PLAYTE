//
//  CreateIngredientTagCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateIngredientTagCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    var delegate: TagCellDelegate?
    private let tagBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.borderColor = UIColor.mainColor?.cgColor
        v.layer.borderWidth = 1.21
        return v
    }()
    
    private let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .mainColor
        return v
    }()
    
    private let deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "multiply"), for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .mainColor
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagBackground.addSubview(tagLabel)
        addSubview(tagBackground)
        contentView.addSubview(deleteButton)
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 20
        setConstant()
        configure(with: "재료입니당",tag: 0)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setConstant() {
        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.bottom.equalTo(tagLabel)
            $0.left.equalTo(tagLabel.snp.right)
        }
        
        tagBackground.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.right.greaterThanOrEqualTo(deleteButton.snp.right).offset(10)
        }
    }
    
    func configure(with title: String, tag: Int) {
        tagLabel.text = title
        deleteButton.tag = tag
    }
    
    func bind() {
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.deleteButtonTapped(sender: self.deleteButton.tag)
            }).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForCreateIngredientTagCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CreateIngredientTagCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateIngredientTagCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateIngredientTagCell()
        .previewLayout(.fixed(width: 100, height: 60))
        .padding(10)
    }
}
#endif
