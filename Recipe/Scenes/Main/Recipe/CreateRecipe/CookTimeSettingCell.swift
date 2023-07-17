//
//  CookTimeSettingCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CookTimeSettingCell: UICollectionViewCell {
    
    ///UI Properties
    private let decreaseButton: DefaultCircleButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "minus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        v.tintColor = .white
        return v
    }()
    
    private let cookTimeLabel: UILabel = {
        let v = UILabel()
        v.text = "0"
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    
    private let cookTimeLine: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private let increaseButton: UIButton = {
        let v = DefaultCircleButton()
        let img = v.buttonImageSize(systemImageName: "plus", size: 20)
        v.setImage(img, for: .normal)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        v.tintColor = .white
        return v
    }()
    ///Properties
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension CookTimeSettingCell {
    
    private func addViews() {
        addSubViews(decreaseButton, cookTimeLabel, cookTimeLine, increaseButton)
    }
    
    private func configureLayout() {
        decreaseButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(decreaseButton.snp.centerY).offset(-10)
            $0.left.equalTo(decreaseButton.snp.right).offset(30)
        }
        
        increaseButton.snp.makeConstraints {
            $0.top.width.height.equalTo(decreaseButton)
            $0.left.equalTo(cookTimeLabel.snp.right).offset(30)
        }
        
        cookTimeLine.snp.makeConstraints {
            $0.top.equalTo(cookTimeLabel.snp.bottom)
            $0.left.width.equalTo(cookTimeLabel)
            $0.height.equalTo(2)
        }
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForCookTimeSettingCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CookTimeSettingCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CookTimeSettingCell_Preview: PreviewProvider {
    static var previews: some View {
        ForCookTimeSettingCell()
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
