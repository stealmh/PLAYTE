//
//  PhotoReviewDefaultCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class PhotoReviewDefaultCell: UICollectionViewCell {
    
    let addPhotoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addReview_photo_svg"), for: .normal)
        return v
    }()

    
    private var disposeBag = DisposeBag()
    weak var delegate: PhotoReviewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        layer.cornerRadius = 10
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension PhotoReviewDefaultCell {
    func addView() {
        addSubViews(addPhotoButton)
    }
    func configureLayout() {
        addPhotoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
}

//MARK: - Method(Rx bind)
extension PhotoReviewDefaultCell {

}

#if DEBUG
import SwiftUI
struct ForPhotoReviewDefaultCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        PhotoReviewDefaultCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PhotoReviewDefaultCell_Preview: PreviewProvider {
    static var previews: some View {
        ForPhotoReviewDefaultCell()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
#endif
