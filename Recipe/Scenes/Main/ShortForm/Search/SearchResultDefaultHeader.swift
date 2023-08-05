//
//  ShortFormSearchHeader.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShortFormSearchHeader: UICollectionReusableView {
    
    /// UI Properties
    // 최신, 인기, 최소 시간순
    private let recentButton = RecipeDefaultTagButton(tagName: "최신", tag: 0)
    private let pupularButton = RecipeDefaultTagButton(tagName: "인기", tag: 1)
    private let minimumButton = RecipeDefaultTagButton(tagName: "최소 시간순", tag: 2)
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        return v
    }()
    /// Properties
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangeViews(recentButton, pupularButton, minimumButton)
        addSubViews(stackView)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension ShortFormSearchHeader {
    func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recentButton.snp.makeConstraints {
            $0.top.left.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
        }
        
        pupularButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        minimumButton.snp.makeConstraints {
            
        }
        
    }
}

//MARK: - Method(Rx bind)
extension ShortFormSearchHeader {}

#if DEBUG
import SwiftUI
struct ForShortFormSearchHeader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormSearchHeader()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForShortFormSearchHeader_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormSearchHeader()
            .previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
