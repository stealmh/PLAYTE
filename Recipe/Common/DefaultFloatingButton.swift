//
//  DefaultFloatingButton.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol FloatingButtonDelegate {
    func floatingButtonTapped()
}

final class DefaultFloatingButton: UIButton {
    
    ///Properties
    private let disposeBag = DisposeBag()
    var delegate: FloatingButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let img = buttonImageSize(imageName: "floating_button", size: 25)
        setImage(img, for: .normal)
        backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind() {
        self.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.floatingButtonTapped()
            }
        ).disposed(by: disposeBag)
    }
}
