//
//  TermsViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit
import PDFKit

class TermsViewController: UIViewController {
    
    private let termLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .grayScale6
        v.text = "플레이트 통합 서비스 약관"
        return v
    }()
    
    private let showPDFButton: UIButton = {
        let v = UIButton()
        v.setTitle("보기", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.setTitleColor(.grayScale4, for: .normal)
        return v
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "이용약관"
        view.backgroundColor = .white
        
        view.addSubview(termLabel)
        view.addSubview(showPDFButton)
        termLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().inset(30)
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        showPDFButton.snp.makeConstraints {
            $0.centerY.equalTo(termLabel)
            $0.right.equalToSuperview().inset(30)
        }
        
        showPDFButton.rx.tap
            .subscribe(onNext: { _ in
                let vc = PDFViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct TermsViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: TermsViewController()).toPreview()
    }
}
