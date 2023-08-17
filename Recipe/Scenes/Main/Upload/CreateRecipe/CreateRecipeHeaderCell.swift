//
//  CreateRecipeHeaderCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CreateRecipeHeaderCell: UICollectionViewCell {
    
    private let headerTitle: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.font = .boldSystemFont(ofSize: 17)
        v.text = "썸네일"
        return v
    }()
    
    private let thumbnailBackground: UIImageView = {
        let v = UIImageView()
        v.layer.borderWidth = 1.5
        v.layer.borderColor = UIColor.grayScale3?.cgColor
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    private let addThumbnailButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addPhoto_svg"), for: .normal)
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        return v
    }()
    
    private let modifyButtonBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .grayScale6?.withAlphaComponent(0.8)
        v.layer.cornerRadius = 12
        return v
    }()
    
    private let modifyButton: UIButton = {
        let v = UIButton()
        v.setTitle("수정", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 12)
        return v
    }()
    
    /// Properties
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(headerTitle, thumbnailBackground, modifyButtonBackground)
        contentView.addSubViews(addThumbnailButton, modifyButton)
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateRecipeHeaderCell {
    func configureLayout() {
        headerTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        thumbnailBackground.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerTitle.snp.bottom).offset(10)
            $0.width.height.equalTo(120)
        }
        
        addThumbnailButton.snp.makeConstraints {
            $0.center.equalTo(thumbnailBackground)
        }
        
        modifyButtonBackground.snp.makeConstraints {
            $0.bottom.right.equalTo(thumbnailBackground).inset(10)
            $0.width.equalTo(41)
            $0.height.equalTo(24)
        }
        
        modifyButton.snp.makeConstraints {
            $0.center.equalTo(modifyButtonBackground)
        }
    }
    
    func bind() {
        addThumbnailButton.rx.tap
            .subscribe(onNext: { _ in
                print("addThumbnailButton tapped")
            }).disposed(by: disposeBag)
        modifyButton.rx.tap
            .subscribe(onNext: { _ in
                print("modifyButton tapped")
            }).disposed(by: disposeBag)
    }
}

import SwiftUI
struct ForCreateRecipeHeaderCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CreateRecipeHeaderCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateRecipeHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateRecipeHeaderCell()
    }
}
