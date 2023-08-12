//
//  TextFieldCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class TextFieldCell: UICollectionViewCell {
    
    ///UI Properties
    let recipeNametextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "placeholder"
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "magnifyingglass", size: 25)
        v.setImage(img, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .gray
        v.isHidden = true
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
extension TextFieldCell {
    
    private func addViews() {
        addSubViews(recipeNametextField, searchImageButton, textCountLabel)
    }
    
    private func setupView() {
        recipeNametextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(recipeNametextField).inset(7)
            $0.width.equalTo(recipeNametextField.snp.height)
            $0.right.equalTo(recipeNametextField).inset(10)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.right.equalTo(recipeNametextField).inset(10)
            $0.centerY.equalTo(recipeNametextField)
        }
    }
    
    func configure(text: String, needSearchButton: Bool) {
        recipeNametextField.placeholder = text
        searchImageButton.isHidden = !needSearchButton
    }
}

//MARK: - Method(Rx Bind)
extension TextFieldCell {
    func bind() {
        recipeNametextField.rx.text.orEmpty
            .scan("") { previous, new in   (new.count > 20) ? previous : new  }
            .subscribe(onNext: { data in
                self.textCountLabel.text = "\(data.count)/20"
                self.recipeNametextField.text = data
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForTextFieldCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        TextFieldCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct TextFieldCell_Preview: PreviewProvider {
    static var previews: some View {
        ForTextFieldCell()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
