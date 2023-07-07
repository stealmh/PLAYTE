//
//  PriceTrendDetailCell.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/06.
//

import UIKit
import SnapKit

class PriceTrendDetailCell: UITableViewCell {

    
    // UI
    private let detailImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    
    private let detailTagBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    
    private let detailTagLabel = UILabel()
    private let detailDateLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        return v
    }()
    
    private let detailTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    
    private let detailTransitionLabel = UILabel()
    
    private let detailContLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        return v
    }()
    
    private let detailPriceLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        v.font = .boldSystemFont(ofSize: 18)
        return v
    }()
    
    private let divideLine: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubViews(detailImageView,detailTagBackground,detailTagLabel,detailDateLabel,detailTitle,detailTransitionLabel,detailContLabel,detailPriceLabel,divideLine)
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
            $0.width.height.equalTo(120)
        }
        
        detailTagBackground.snp.makeConstraints {
            $0.top.equalTo(detailImageView).inset(10)
            $0.left.equalTo(detailImageView.snp.right).offset(30)
            $0.width.equalTo(65)
            $0.height.equalTo(30)
        }
        
        detailTagLabel.snp.makeConstraints {
            $0.center.equalTo(detailTagBackground)
        }
        
        detailDateLabel.snp.makeConstraints {
            $0.top.equalTo(detailTagBackground).inset(5)
            $0.right.equalToSuperview().inset(20)
        }
        
        detailTitle.snp.makeConstraints {
            $0.left.equalTo(detailTagBackground).inset(5)
            $0.top.equalTo(detailTagBackground.snp.bottom).offset(10)
        }
        
        detailContLabel.snp.makeConstraints {
            $0.right.equalTo(detailDateLabel)
            $0.top.equalTo(detailTitle)
        }
        
        detailTransitionLabel.snp.makeConstraints {
            $0.left.equalTo(detailTitle)
            $0.top.equalTo(detailTitle.snp.bottom).offset(10)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.bottom.equalTo(detailTransitionLabel)
            $0.width.equalTo(2)
            $0.right.equalTo(detailDateLabel.snp.left).inset(-10)
        }
        
        detailPriceLabel.snp.makeConstraints {
            $0.right.equalTo(detailContLabel)
            $0.top.equalTo(detailTransitionLabel)
            $0.left.equalTo(divideLine).inset(10)
        }
    }
    
    func setMockData() {
        detailImageView.image = UIImage(named: "popcat")!
        detailTagLabel.text = "유제품"
        detailDateLabel.text = "05/13 기준"
        detailTitle.text = "계란"
        detailContLabel.text = "1개"
        detailTransitionLabel.text = "+8원 (0.4%)"
        detailPriceLabel.text = "10000000원"
    }
    
    func setData(data: PriceTrend) {
        detailImageView.image = data.image
        detailTagLabel.text = data.tagName
        detailDateLabel.text = data.date
        detailTitle.text = data.title
        detailContLabel.text = "\(data.count)개"
        detailTransitionLabel.text = data.transition
        detailPriceLabel.text = "\(data.price)원"
    }

}

#if DEBUG
import SwiftUI
struct ForPriceTrendDetailCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        PriceTrendDetailCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PriceTrendDetailCellPreview: PreviewProvider {
    static var previews: some View {
        ForPriceTrendDetailCell()
            .previewLayout(.fixed(width: 393, height: 160))
    }
}
#endif
