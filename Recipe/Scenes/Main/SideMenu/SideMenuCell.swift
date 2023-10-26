//
//  SideMenuCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/10/26.
//

import UIKit
import SnapKit

class SideMenuCell: UITableViewCell {
    
    private let contentLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let alertTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        return v
    }()
    
    private let contentImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubViews(contentLabel, alertTimeLabel, contentImageView)
        configureLayout()
        #if DEBUG
        mockData()
        #endif
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
        contentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(contentImageView).inset(5)
            $0.right.equalTo(contentImageView.snp.left).offset(-20)
        }
        
        alertTimeLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(contentLabel)
        }
        
        contentImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func mockData() {
        contentLabel.text = "가나다라마바사님이 회원님의 레시피를 좋아합니다."
        alertTimeLabel.text = "8시간 전"
        contentImageView.image = UIImage(named: "popcat")
    }
    
}

#if DEBUG
import SwiftUI
struct ForSideMenuCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        SideMenuCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct SideMenuCellPreview: PreviewProvider {
    static var previews: some View {
        ForSideMenuCell()
            .previewLayout(.fixed(width: 393, height: 100))
    }
}
#endif
