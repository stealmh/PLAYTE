//
//  TagCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol TagCellDelegate {
    func deleteButtonTapped(sender: Int)
}
class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    let disposeBag = DisposeBag()
    let tagBackground: UIView = {
    var delegate: TagCellDelegate?
        let v = UIView()
        v.backgroundColor = .white
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let tagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 14)
        v.textColor = .gray
        return v
    }()
    
    let deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .gray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagBackground)
        contentView.addSubview(tagLabel)
        contentView.addSubview(deleteButton)
        tagBackground.layer.masksToBounds = true
        tagBackground.layer.cornerRadius = 15
        setConstant()
        configure(with: "hello",tag: 0)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstant() {
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
//        tagBackground.translatesAutoresizingMaskIntoConstraints = false
//        tagBackground.frame = contentView.frame
//
        tagBackground.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-9)
            $0.right.equalToSuperview().offset(8.6)
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
struct ForProfileHeaderCell12: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        TagCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ProfileHeaderPreview12: PreviewProvider {
    static var previews: some View {
        ForProfileHeaderCell12()
        .previewLayout(.fixed(width: 100, height: 60))
        .padding(10)
    }
}
#endif
