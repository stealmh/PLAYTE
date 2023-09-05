//
//  RecentSearchHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RecentSearchDelegate: AnyObject {
    func didTappedDeleteKeyword()
}

class RecentSearchHeader: UICollectionReusableView {
    
    private let recentSearchTitle: UILabel = {
        let v = UILabel()
        v.text = "최근 검색어"
        v.textColor = .black
        v.font = .boldSystemFont(ofSize: 18)
        return v
    }()
    
    let clearButton: UIButton = {
        let v = UIButton()
        v.setTitle("모두 지우기", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.setTitleColor(.grayScale4, for: .normal)
        v.isEnabled = true
        return v
    }()
    
    private var disposeBag = DisposeBag()
    weak var delegate: RecentSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(recentSearchTitle, clearButton)
        configureLayout()
        bind()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension RecentSearchHeader {
    func configureLayout() {
        recentSearchTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
            $0.height.equalTo(17)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.height.equalTo(recentSearchTitle)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    func bind() {
        clearButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedDeleteKeyword()
            }).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForRecentSearchHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecentSearchHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForRecentSearchHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForRecentSearchHeader()
            .previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
