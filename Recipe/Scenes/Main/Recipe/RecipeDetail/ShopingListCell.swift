//
//  ShopingListCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/23.
//

import UIKit
import SnapKit

struct ShopingList: Hashable {
    let id = UUID()
    let title: String
    let price: Int
    let image: String
    let isrocket: Bool
    let link: String
}

final class ShopingListCell: UICollectionViewCell {
    
    private let shopingTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 13.76)
        return v
    }()
    
    private let shopingPriceLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 13.76)
        return v
    }()
    
    private let shopingPhotoImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 7
        v.clipsToBounds = true
        return v
    }()
    
    private let deliveryImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        mockConfigure()
        backgroundConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension ShopingListCell {
    func addView() {
        addSubViews(shopingTitleLabel, shopingPriceLabel, shopingPhotoImageView, deliveryImageView)
    }
    func configureLayout() {
        shopingPhotoImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(10)
            $0.width.equalTo(80)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        shopingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(shopingPhotoImageView).inset(5)
            $0.left.equalTo(shopingPhotoImageView.snp.right).offset(10)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(14)
        }
        
        shopingPriceLabel.snp.makeConstraints {
            $0.left.equalTo(shopingTitleLabel)
            $0.top.equalTo(shopingTitleLabel.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(14)
        }
        deliveryImageView.snp.makeConstraints {
            $0.left.equalTo(shopingTitleLabel).offset(-5)
            $0.top.equalTo(shopingPriceLabel.snp.bottom).offset(10)
        }
    }
    
    private func backgroundConfigure() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0 , height:3)
    }
    
    //for data inject
    func configure(_ item: ShopingList) {
        DispatchQueue.main.async {
            self.shopingTitleLabel.text = item.title
            self.shopingPriceLabel.text = "₩\(item.price)원 ~"
            self.shopingPhotoImageView.loadImage(from: item.image)
            self.deliveryImageView.image = UIImage(named: "rocket")
            self.deliveryImageView.isHidden = !item.isrocket
        }
    }
    
    func mockConfigure() {
        shopingTitleLabel.text = "전남 국내산 대추방울 토마토"
        shopingPriceLabel.text = "₩18,000원 ~"
        shopingPhotoImageView.image = UIImage(named: "popcat")
        deliveryImageView.image = UIImage(named: "rocket")
    }
}

//MARK: - Method(Rx bind)
extension ShopingListCell {
    func bind() {}
}

#if DEBUG
import SwiftUI
struct ForShopingListCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShopingListCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ShopingListCell_Preview: PreviewProvider {
    static var previews: some View {
        ForShopingListCell()
            .previewLayout(.fixed(width: 240, height: 94))
    }
}
#endif
