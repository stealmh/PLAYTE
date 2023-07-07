//
//  NormalRefrigeratorView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class NormalRefrigeratorView: UIView {
    
    let disposeBag = DisposeBag()
    var delegate: TestViewDelegate?
    
    private let sinseonButton: UIButton = {
        let v = UIButton()
        v.setTitle("신선 식품", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let joriButton: UIButton = {
        let v = UIButton()
        v.setTitle("조리 재료", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let breadButton: UIButton = {
        let v = UIButton()
        v.setTitle("빵/과자", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    //
    private let drinkButton: UIButton = {
        let v = UIButton()
        v.setTitle("음료", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let mealkitButton: UIButton = {
        let v = UIButton()
        v.setTitle("밀키트", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let banchanButton: UIButton = {
        let v = UIButton()
        v.setTitle("반찬", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let etcButton: UIButton = {
        let v = UIButton()
        v.setTitle("기타", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        
        addSubViews(
            sinseonButton,
            joriButton,
            breadButton,
            drinkButton,
            mealkitButton,
            banchanButton,
            etcButton)
        setUI()
        bindButtonTap()
        
        [sinseonButton,
        joriButton,
        breadButton,
        drinkButton,
        mealkitButton,
        banchanButton,
         etcButton].forEach { $0.addTarget(self, action: #selector(check(sender:)), for: .touchUpInside) }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// Method
extension NormalRefrigeratorView {
    func setUI() {
        sinseonButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        joriButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(sinseonButton.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        breadButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(joriButton.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        drinkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        
        mealkitButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(sinseonButton.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        
        banchanButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(joriButton.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2).inset(10)
            $0.height.equalToSuperview().dividedBy(4).inset(10)
        }
        
        etcButton.snp.makeConstraints {
            $0.top.equalTo(banchanButton.snp.bottom).offset(10)
            $0.left.equalTo(breadButton)
            $0.right.equalTo(banchanButton)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bindButtonTap() {
        sinseonButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        joriButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        breadButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        drinkButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        mealkitButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        banchanButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        etcButton.rx.tap
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
    }
}

private extension NormalRefrigeratorView {
    @objc func check(sender: UIButton) {
        print(#function)
        delegate?.onClickButton(sender.currentTitle!)
    }
}

#if DEBUG
import SwiftUI
struct ForNormalRefrigeratorView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        NormalRefrigeratorView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct NormalRefrigeratorViewPreview: PreviewProvider {
    static var previews: some View {
        ForNormalRefrigeratorView()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
#endif

import SwiftUI
struct ViewController1_preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview()
    }
}
