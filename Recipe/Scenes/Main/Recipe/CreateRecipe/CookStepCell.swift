//
//  CookStepCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CookStepCell: UICollectionViewCell {
    
    ///UI Properties
    private let stepBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let stepLabel: UILabel = {
        let v = UILabel()
        v.text = "물을 끓이고 100원 동전만큼 파스타면을 넣는다"
        v.font = .systemFont(ofSize: 15)
        v.textColor = .mainColor
        return v
    }()
    
    private let stepMoveButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "hamburger"), for: .normal)
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
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    var defaultCheck = BehaviorRelay(value: true)
    let imageSelectSubject = PublishRelay<UIImage>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
//        configureLayout()
//        defaultSetting()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        defaultCheck.subscribe(onNext: { isNewData in
            if isNewData {
                self.stepBackground.addDashedBorder()
                self.defaultSetting()
            } else {
                self.configureLayout()
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - Method(Normal)
extension CookStepCell {
    
    private func addViews() {
        addSubViews(stepBackground, stepLabel, stepMoveButton, selectImageView, addPhotoButton)
    }
    
    private func configureLayout() {
        stepBackground.layer.borderWidth = 1
        stepBackground.layer.borderColor = UIColor.mainColor?.cgColor
        
        stepBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.left.equalTo(stepBackground).inset(10)
            $0.right.equalTo(stepMoveButton).inset(30)
        }
        
        stepMoveButton.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.right.equalTo(stepBackground).inset(10)
        }
    }
    
    func defaultSetting() {
        stepLabel.text = "레시피를 입력해주세요."
        stepLabel.textColor = .gray.withAlphaComponent(0.4)
        stepMoveButton.setImage(UIImage(named: "hamburger_gray"), for: .normal)
        stepBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.left.equalTo(stepBackground).inset(10)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.right.equalTo(stepMoveButton.snp.left).offset(-20)
        }
        
        selectImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(stepBackground).inset(5)
            $0.right.equalTo(stepMoveButton.snp.left).offset(-20)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        
        stepMoveButton.snp.makeConstraints {
            $0.centerY.equalTo(stepBackground)
            $0.right.equalTo(stepBackground).inset(10)
        }
    }
    func addSetting(text: String) {
        stepLabel.text = text
    }
}

extension CookStepCell {
    func bind() {
        imageSelectSubject.subscribe(onNext: { img in
            self.selectImageView.image = img
        }).disposed(by: disposeBag)
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForCookStepCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CookStepCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CookStepCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCookStepCell()
            .previewLayout(.fixed(width: 339, height: 42))
    }
}
