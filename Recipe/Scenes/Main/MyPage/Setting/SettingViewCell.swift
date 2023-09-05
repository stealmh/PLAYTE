//
//  SettingViewCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import SnapKit

class SettingViewCell: UITableViewCell {
    
    private let cellTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale6
        return v
    }()
    
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        v.textAlignment = .right
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellTitleLabel)
        addSubview(nickNameLabel)
        cellTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(20)
            $0.height.equalTo(19)
            $0.width.equalTo(100)
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(cellTitleLabel)
            $0.height.equalTo(14)
            $0.left.equalTo(cellTitleLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10)
        }
        mockConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ nickName: String?) {
        cellTitleLabel.text = title
        if let nickName {
            nickNameLabel.text = nickName
        } else {
            nickNameLabel.text = nil
        }
    }
    
    func configureLogout() {
        cellTitleLabel.textColor = .mainColor
    }
    
    func configureWithdrawal() {
        cellTitleLabel.textColor = .grayScale4
    }
    
    func mockConfigure() {
        cellTitleLabel.text = "닉네임 관리"
        nickNameLabel.text = "냉파쿵야"
    }
}

#if DEBUG
import SwiftUI
struct ForSettingViewCell: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        SettingViewCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct SettingViewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForSettingViewCell()
        .previewLayout(.fixed(width: 390, height: 60))
    }
}
#endif
