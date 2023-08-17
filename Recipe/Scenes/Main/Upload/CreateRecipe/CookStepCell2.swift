//
//  CookStepCell2.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/17.
//

import Foundation

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CookStepCell2: UICollectionViewListCell {
    
    ///UI Properties
    private let stepBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        return v
    }()
    
    let stepTextfield: PaddingUITextField = {
        let v = PaddingUITextField()
//        v.text = "레시피를 입력해주세요."
        v.placeholder = "레시피를 입력해주세요."
        return v
    }()
    
    let addPhotoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        v.tintColor = .gray
        return v
    }()
    
    let selectImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    
    ///Properties
    let disposeBag = DisposeBag()
    var defaultCheck = BehaviorRelay(value: false)
    let imageSelectSubject = PublishRelay<UIImage>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddView()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        stepBackground.addDashedBorder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectImageView.image = nil
    }
}

//MARK: - Method
extension CookStepCell2 {
    private func setAddView() {
        addSubViews(stepBackground, stepTextfield, selectImageView, addPhotoButton)
    }
    
    private func configureLayout() {
        stepBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stepTextfield.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.5)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.right.equalTo(self.snp.right).offset(-20)
        }
        
        selectImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(stepBackground).inset(5)
            $0.left.equalTo(stepTextfield.snp.right)
            $0.right.equalTo(addPhotoButton.snp.left).offset(-20)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
    }
    
    private func bind() {
        imageSelectSubject.subscribe(onNext: { img in
            self.selectImageView.image = img
        }).disposed(by: disposeBag)
    }
}
