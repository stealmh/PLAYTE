//
//  AnswerCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import UIKit
import SnapKit

class AnswerCell: UITableViewCell {
    
    let guideLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.numberOfLines = 0
        return v
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeButton_svg"), for: .normal)
        button.tintColor = .grayScale5
        return button
    }()
    
    var section: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = .sub1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
//        addSubview(guideLabel)
//        addSubview(closeButton)
        contentView.addSubview(guideLabel)
        contentView.addSubview(closeButton)
        // `guideLabel`에 제약 조건 설정
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(15)
            $0.bottom.lessThanOrEqualTo(closeButton.snp.top).offset(-10)
        }
        
        // `closeButton`에 제약 조건 설정
        closeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)  // 닫기 버튼 크기를 10에서 40으로 조절하였습니다.
        }
    }
    
    func configureTextSpacing(_ txt: String) {
        let attributedText = NSMutableAttributedString(string: txt)
        
        let letterSpacing: CGFloat = 10
        attributedText.addAttribute(NSAttributedString.Key.kern,
                                    value: letterSpacing,
                                    range: NSRange(location: 0, length: attributedText.length))
        
        guideLabel.attributedText = attributedText
    }
}
