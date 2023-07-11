//
//  RegisterSucessView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class RegisterSucessView: UIView {
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "RE:cipe\n가입을 축하드려요"
        v.numberOfLines = 2
        v.textAlignment = .center
        v.font = .boldSystemFont(ofSize: 22)
        v.textColor = .white
        return v
    }()
    
    private let subTitleLabel: UILabel = {
        let v = UILabel()
        v.text = "당신만을 위한 맛있는 레시피를 제공해드려요."
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        return v
    }()
    
    private let sucessButton: UIButton = {
        let v = UIButton()
        v.setTitle("완료", for: .normal)
        v.tintColor = .white
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    
    private let disposeBag = DisposeBag()
    var delegate: RegisterViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubViews(titleLabel, subTitleLabel, sucessButton)
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method
extension RegisterSucessView {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(344)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top).offset(426-344)
            $0.centerX.equalToSuperview()
        }

        
        sucessButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56)
        }
    }
    
    private func bind() {
        sucessButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTapNextButton()
            }
        ).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
private struct ForRegisterSucessView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RegisterSucessView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
private struct RegisterSucessView_Preview: PreviewProvider {
    static var previews: some View {
        ForRegisterSucessView()
    }
}
#endif
