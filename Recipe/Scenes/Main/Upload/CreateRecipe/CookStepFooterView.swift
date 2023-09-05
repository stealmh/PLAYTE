//
//  CookStepFooterView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol CookStepRegisterDelegate: AnyObject {
    func didTappedRegisterButton()
}

final class CookStepFooterView: UICollectionReusableView {
    static let identifier = "CookStepFooterView"
    
    ///UI Properties
    let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("등록", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
//        v.isEnabled = false
        return v
    }()
    
    ///Properties
    private var disposeBag = DisposeBag()
    weak var delegate: CookStepRegisterDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddView()
        configureLayout()
        
        registerButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedRegisterButton()
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

//MARK: - Method
extension CookStepFooterView {
    private func setAddView() {
        addSubViews(registerButton)

    }
    
    private func configureLayout() {
        registerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
