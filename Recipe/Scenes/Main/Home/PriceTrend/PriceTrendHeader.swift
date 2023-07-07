//
//  MulgaHeader.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PriceTrendHeader: UICollectionReusableView {
    static let identifier = "MulgaHeader"
    let disposeBag = DisposeBag()
    private let label = UILabel()
    private let button: UIButton = {
        let v = UIButton()
        v.setTitle("전체보기", for: .normal) //title넣기
        v.setImage(UIImage(systemName: "chevron.right"), for: .normal)// 이미지 넣기
        v.setTitleColor(.black, for: .normal)
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 12)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceRightToLeft //<- 중v
        v.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let stackView = UIStackView()
    
    var delegate: PriceTrendHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        label.text = "식재료 물가 추이"
        label.font = .boldSystemFont(ofSize: 17)
//        backgroundColor = .red
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        stackView.frame = bounds
//        stackView.backgroundColor = .green
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        button.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.showAllData()
            }).disposed(by: disposeBag)
    }
}

import SwiftUI
struct ViewController1231_preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview()
    }
}
