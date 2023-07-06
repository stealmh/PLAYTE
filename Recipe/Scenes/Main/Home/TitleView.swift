//
//  TitleView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitleView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let iceButton: UIButton = {
        let v = UIButton()
        v.setTitle("냉장/냉동", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    
    let notIceButton: UIButton = {
        let v = UIButton()
        v.setTitle("실온", for: .normal)
        v.setTitleColor(.lightGray, for: .normal)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(iceButton, notIceButton)
        setUI()
        
        notIceButton.rx.tap
            .subscribe(onNext: { _ in
                print("tapped")
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        iceButton.snp.makeConstraints {
            $0.top.centerY.equalToSuperview()
            $0.right.equalTo(self.snp.centerX).offset(10)
        }
        
        notIceButton.snp.makeConstraints {
            $0.top.centerY.equalToSuperview()
            $0.left.equalTo(self.snp.centerX).offset(20)
        }
    }
}

import SwiftUI
struct ForTitleView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        TitleView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct TitleViewPreview: PreviewProvider {
    static var previews: some View {
        ForTitleView()
        .previewLayout(.fixed(width: 393, height: 50))
    }
}

