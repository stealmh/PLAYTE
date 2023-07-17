//
//  CreateRecipeHeaderView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CreateRecipeHeaderCell: UICollectionViewCell {
    
    ///UI Properties
    private let createRecipeTitle: UILabel = {
        let v = UILabel()
        v.text = "나의 레시피 작성"
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    private let headerBackground = UIView()
    
    private let addPhotoView: UIImageView = {
        let v = UIImageView()
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 11.1
        return v
    }()
    
    private let addPhotoButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "plus.square", size: 30)
        v.setImage(img, for: .normal)
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
//MARK: - Method(Normal)
extension CreateRecipeHeaderCell {
    private func addViews() {
        headerBackground.addSubview(addPhotoView)
        headerBackground.addSubview(addPhotoButton)
        headerBackground.addSubview(createRecipeTitle)
        addSubViews(headerBackground)
    }
    
    private func configureLayout() {
        headerBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addPhotoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(createRecipeTitle.snp.bottom).offset(30)
            $0.width.height.equalTo(100)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.center.equalTo(addPhotoView)
        }
        
        createRecipeTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForCreateRecipeHeaderView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CreateRecipeHeaderCell()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateRecipeHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateRecipeHeaderView()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
