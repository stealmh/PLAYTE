//
//  ShortFormSheetViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SheetActionDelegate: AnyObject {
    func didTappedNoInterest()
    func didTappedReport()
    func didTappedUserReport()
}

class ShortFormSheetViewController: BaseViewController {
    
    /// UI Properties
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
//        v.alignment = .fill
        v.alignment = .leading
        v.distribution = .fillEqually
        return v
    }()
    
    private let noInterestButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "nointerest_svg"), for: .normal)
        v.setTitle("관심 없음", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.setTitleColor(.grayScale5, for: .normal)
        let spacing: CGFloat = 10
        v.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        v.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
        return v
    }()
    
    private let banButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "ban_svg"), for: .normal)
        v.setTitle("신고하기", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.setTitleColor(.grayScale5, for: .normal)
        let spacing: CGFloat = 10
        v.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        v.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
        return v
    }()
    
    private let sendButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "send_svg"), for: .normal)
        v.setTitle("사용자 차단하기", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.setTitleColor(.grayScale5, for: .normal)
        let spacing: CGFloat = 10
        v.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        v.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
//        v.isHidden = true
        return v
    }()
    
    private let sheetLine: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "sheet_svg")
        return v
    }()
    /// Properties
    private let disposeBag = DisposeBag()
    weak var delegate: SheetActionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.addArrangedSubview(noInterestButton)
        stackView.addArrangedSubview(banButton)
        stackView.addArrangedSubview(sendButton)
        view.addSubViews(sheetLine, stackView)
        view.layer.cornerRadius = 15
        configureLayout()
        bind()
    }
}

extension ShortFormSheetViewController {
    func configureLayout() {
        
        sheetLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
            $0.width.equalTo(59)
            $0.height.equalTo(6)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(sheetLine.snp.bottom).offset(10)
            $0.right.equalToSuperview()
            $0.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        noInterestButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedNoInterest()
            }).disposed(by: disposeBag)
        
        banButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedReport()
            }).disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedUserReport()
            }).disposed(by: disposeBag)
    }
}

//MARK: - VC Preview
import SwiftUI
import AVKit
struct ShortFormSheetViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: ShortFormSheetViewController())
            .toPreview()
            .previewLayout(.fixed(width: 393, height: 300))
            .ignoresSafeArea()
    }
}
