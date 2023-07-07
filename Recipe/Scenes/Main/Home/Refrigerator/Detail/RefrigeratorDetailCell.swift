//
//  RefrigeratorDetailCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/06.
//

import UIKit
import SnapKit

class RefrigeratorDetailCell: UITableViewCell {

    
    // UI
    let detailImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    
    let ingredientTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    
    let expirationDateLabel = UILabel()
    let deleteButton: UIButton = {
        let v = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "trash", withConfiguration: imageConfig)
        v.setImage(image, for: .normal)
        v.tintColor = .gray
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubViews(detailImageView,ingredientTitle,expirationDateLabel,deleteButton)
        setUI()
        setMockData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        detailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(90)
        }
        
        ingredientTitle.snp.makeConstraints {
            $0.left.equalTo(detailImageView.snp.right).offset(20)
            $0.top.equalTo(detailImageView).offset(20)
        }
        
        expirationDateLabel.snp.makeConstraints {
            $0.left.equalTo(ingredientTitle)
            $0.top.equalTo(ingredientTitle.snp.bottom).offset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(ingredientTitle)
        }

    }
    
    func setMockData() {
        detailImageView.image = UIImage(named: "popcat")!
//        detailTagLabel.text = "유제품"
//        detailDateLabel.text = "05/13 기준"
        ingredientTitle.text = "계란"
//        detailContLabel.text = "1개"
        expirationDateLabel.text = "2023/02/12"
//        detailPriceLabel.text = "10000000원"
    }
    
    func setData(data: PriceTrend) {
        detailImageView.image = UIImage(named: "popcat")!
        ingredientTitle.text = "계란"
        expirationDateLabel.text = "2023/02/12"
    }

}

#if DEBUG
import SwiftUI
struct ForRefrigeratorDetailCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RefrigeratorDetailCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RefrigeratorDetailCellPreview: PreviewProvider {
    static var previews: some View {
        ForRefrigeratorDetailCell()
            .previewLayout(.fixed(width: 393, height: 130))
    }
}
#endif
