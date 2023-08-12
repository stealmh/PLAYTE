//
//  MyReviewCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol MyReviewCellDelegate: AnyObject {
    func deleteButtonTapped(_ cell: MyReviewCell)
    func moveReviewButtonTapped(_ cell: MyReviewCell)
}

class MyReviewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// UI Properties
    private let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale5
        v.textAlignment = .left
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 18)
        v.textColor = .black
        return v
    }()
    private let moveReviewButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "moveReview_svg"), for: .normal)
        return v
    }()
    private let rateStack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
//        v.spacing = 5
        return v
    }()
    private let rate1: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_fill_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    private let rate2: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let rate3: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let rate4: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let rate5: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "star_empty_svg")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "delete_svg"), for: .normal)
        return v
    }()
    private let photos: [UIImage] = [UIImage(named: "popcat")!,
                                     UIImage(named: "popcat")!]
    
    private let reviewContents: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale6
        v.numberOfLines = 0
        return v
    }()
    
    private let reviewContentsBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .grayScale1
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        return v
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    /// Properties
    let disposeBag = DisposeBag()
    weak var delegate: MyReviewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mockData()
        addView()
        configureLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(cellType: MyReviewPhotoCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        
        moveReviewButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.moveReviewButtonTapped(self)
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.deleteButtonTapped(self)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
        return 23
    }
    
    // UICollectionViewDataSource and UICollectionViewDelegateFlowLayout methods...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewPhotoCell.reuseIdentifier, for: indexPath) as! MyReviewPhotoCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension MyReviewCell {
    func addView() {
        rateStack.addArrangeViews(rate1, rate2, rate3, rate4, rate5)
        rateStack.addArrangedSubview(rate1)
        rateStack.addArrangedSubview(rate2)
        rateStack.addArrangedSubview(rate3)
        rateStack.addArrangedSubview(rate4)
        rateStack.addArrangedSubview(rate5)
        reviewContentsBackground.addSubview(reviewContents)
        addSubViews(rateStack, uploadTimeLabel, titleLabel, reviewContentsBackground)
        contentView.addSubview(moveReviewButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(collectionView)
    }
    
    func configureLayout() {
        uploadTimeLabel.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(17)
            $0.top.left.equalToSuperview().inset(10)
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalTo(uploadTimeLabel)
            $0.top.equalTo(uploadTimeLabel.snp.bottom).offset(5)
            $0.height.equalTo(21)
            $0.width.greaterThanOrEqualTo(10)
        }
        
        moveReviewButton.snp.makeConstraints {
            $0.top.height.equalTo(titleLabel)
            $0.left.equalTo(titleLabel.snp.right).offset(5)
            $0.width.greaterThanOrEqualTo(10)
        }

        rateStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel)
            $0.width.equalTo(127.6)
            $0.height.equalTo(29)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.height.equalTo(rateStack)
            $0.right.equalToSuperview().inset(10)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(rateStack.snp.bottom).offset(10)
            $0.left.equalTo(rateStack)
            $0.height.equalTo(100)
            $0.right.equalToSuperview()
        }
        
        reviewContentsBackground.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10).priority(.low)
        }
        
        reviewContents.snp.makeConstraints {
            $0.top.left.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10).priority(.low)
        }
    }
    
    func mockData() {
        uploadTimeLabel.text = "2023/02/12"
        titleLabel.text = "토마토 계란 볶음밥"
        reviewContents.text = "리뷰띠"
    }
}

#if DEBUG
import SwiftUI
struct ForMyReviewCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MyReviewCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct MyReviewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForMyReviewCell()
            .previewLayout(.fixed(width: 380, height: 300))
    }
}
#endif
