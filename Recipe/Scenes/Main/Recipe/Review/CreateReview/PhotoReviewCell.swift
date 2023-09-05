//
//  PhotoReviewCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/31.
//

import UIKit
import SnapKit
import RxSwift

protocol PhotoReviewCellDelegate: AnyObject {
    func deleteTapped(cell: PhotoReviewCell)
}

final class PhotoReviewCell: UICollectionViewCell {
    
    private let imgView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        v.clipsToBounds = true
        return v
    }()
    
    let deleteButton: DefaultCircleButton = {
        let v = DefaultCircleButton()
        v.setImage(UIImage(systemName: "minus"), for: .normal)
        v.layer.cornerRadius = 30
        v.clipsToBounds = true
        v.tintColor = .white
        return v
    }()
    
    private var disposeBag = DisposeBag()
    weak var delegate: PhotoReviewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    override func prepareForReuse() {
//        print(#function)
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
}

//MARK: - Method(Normal)
extension PhotoReviewCell {
    func addView() {
        addSubViews(imgView, deleteButton)
    }
    func configureLayout() {
//        imgView.image = UIImage(named: "popcat")
        imgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(imgView).offset(-10)
            $0.right.equalTo(imgView)
        }
    }
    func configure(_ item: UIImage) {
        DispatchQueue.main.async {
            self.imgView.image = item
        }

    } //for data inject
}

//MARK: - Method(Rx bind)
extension PhotoReviewCell {
    func bind() {
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.deleteTapped(cell: self)
            }).disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
struct ForPhotoReviewCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        PhotoReviewCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PhotoReviewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForPhotoReviewCell()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
#endif
