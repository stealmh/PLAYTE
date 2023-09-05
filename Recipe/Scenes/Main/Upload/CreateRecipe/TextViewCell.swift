//
//  TextViewCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class TextFieldViewCell: UICollectionViewCell {
    
    ///UI Properties
    let textView: UITextView = {
        let v = UITextView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return v
    }()
    
    private let placeholderLabel: UILabel = {
        let v = UILabel()
        v.text = "레시피에 대한 설명을 간략히 입력해주세요"
        v.textColor = .gray
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let textCountLabel: UILabel = {
        let v = UILabel()
        v.text = "0/20"
        v.textColor = .gray
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension TextFieldViewCell {
    
    private func addViews() {
        addSubViews(textView, placeholderLabel, textCountLabel)
    }
    
    private func setupView() {
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).inset(10)
            $0.left.equalTo(textView).inset(23)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.right.bottom.equalTo(textView).inset(20)
        }
    }
    
}

//MARK: - Method(Rx Bind)
extension TextFieldViewCell {
    func bind() {
        textView.rx.text.orEmpty
            .scan("") { previous, new in   (new.count > 100) ? previous : new  }
            .subscribe(onNext: { data in
                DispatchQueue.main.async {
                    self.placeholderLabel.isHidden = data.isEmpty ? false : true
                    self.textCountLabel.text = "\(data.count)/100"
                    self.textView.text = data
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForTextFieldViewCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        TextFieldViewCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct TextViewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForTextFieldViewCell()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
