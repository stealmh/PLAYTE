//
//  ReviewHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class ReviewHeader: UICollectionReusableView {
    static let identifier = "ReviewHeader"
    
    private let headerTitle: UILabel = {
        let v = UILabel()
        v.text = "리뷰 0개"
        v.textColor = .mainColor
        v.asColor(targetString: "리뷰", color: .black)
        v.font = .boldSystemFont(ofSize: 18)
        return v
    }()
    
    private let bestButton: UIButton = {
        let v = UIButton()
        v.setTitle("베스트순", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    
    private let recentButton: UIButton = {
        let v = UIButton()
        v.setTitle("최신순", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        return v
    }()
    
    private let buttonDivideLine: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.lineColor?.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension ReviewHeader {
    func addView() {
        addSubViews(headerTitle, bestButton, recentButton, buttonDivideLine)
    }
    func configureLayout() {
        headerTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
        }
        
        bestButton.snp.makeConstraints {
            $0.centerY.equalTo(headerTitle)
            $0.right.equalTo(buttonDivideLine.snp.left).offset(-10)
        }
        
        buttonDivideLine.snp.makeConstraints {
            $0.top.bottom.equalTo(headerTitle)
            $0.width.equalTo(1)
            $0.right.equalTo(recentButton.snp.left).offset(-10)
        }
        
        recentButton.snp.makeConstraints {
            $0.centerY.equalTo(headerTitle)
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(_ count: Int) {
        DispatchQueue.main.async {
            self.headerTitle.text = "리뷰 \(count)개"
            self.headerTitle.asColor(targetString: "리뷰", color: .black)
        }
    }
}

//MARK: - Method(Rx bind)
extension ReviewHeader {
    func bind() {
        bestButton.rx.tap
            .subscribe(onNext: { _ in
                self.bestButton.setTitleColor(.black, for: .normal)
                self.recentButton.setTitleColor(.gray, for: .normal)
            }
        ).disposed(by: disposeBag)
        
        recentButton.rx.tap
            .subscribe(onNext: { _ in
                self.recentButton.setTitleColor(.black, for: .normal)
                self.bestButton.setTitleColor(.gray, for: .normal)
            }
        ).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForReviewHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ReviewHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ReviewHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForReviewHeader()
            .previewLayout(.fixed(width: 393, height: 50))
        //        .padding(10)
    }
}
#endif
