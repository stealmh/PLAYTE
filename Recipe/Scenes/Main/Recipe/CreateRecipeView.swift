//
//  CreateRecipeView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateRecipeView: UIView {
    
    
    /// UI Properties
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
    
    private let recipeNameLabel: UILabel = {
        let v = UILabel()
        v.text = "레시피 이름"
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    
    private let recipeNameTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.placeholder = "레시피 이름을 입력해주세요."
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let recipeIngredientLabel: UILabel = {
        let v = UILabel()
        v.text = "레시피 재료"
        v.font = .boldSystemFont(ofSize: 20)
        return v
    }()
    
    private let recipeIngredientTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.placeholder = "레시피 이름을 검색해주세요."
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "magnifyingglass", size: 25)
        v.setImage(img, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .gray
        return v
    }()
    
    private let cookTimeLabel: UILabel = {
        let v = UILabel()
        v.text = "조리 시간 분"
        v.font = .boldSystemFont(ofSize: 20)
        v.asColor(targetString: "분", color: .gray)
        return v
    }()
    
    private let decreaseButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(imageName: "floating_button", size: 25)
        v.setImage(img, for: .normal)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        return v
    }()
    
    private let increaseButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "minus", size: 30)
        v.setImage(img, for: .normal)
        return v
    }()
    
    /// Properties
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [increaseButton, decreaseButton].forEach { $0.layer.cornerRadius = 0.5 * bounds.size.width }
    }

}

//MARK: - Method(Normal)
extension CreateRecipeView {
    func addView() {
        addSubViews(addPhotoView, addPhotoButton, recipeNameLabel, recipeNameTextField, recipeIngredientLabel, recipeIngredientTextField, searchImageButton, cookTimeLabel, decreaseButton, increaseButton)
    }
    func configureLayout() {
        addPhotoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(110)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.center.equalTo(addPhotoView)
        }
        
        recipeNameLabel.snp.makeConstraints {
            $0.top.equalTo(addPhotoView.snp.bottom).offset(50)
            $0.left.equalToSuperview().inset(40)
        }
        
        recipeNameTextField.snp.makeConstraints {
            $0.top.equalTo(recipeNameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        recipeIngredientLabel.snp.makeConstraints {
            $0.top.equalTo(recipeNameTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(40)
        }
        
        recipeIngredientTextField.snp.makeConstraints {
            $0.top.equalTo(recipeIngredientLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(recipeIngredientTextField).inset(7)
            $0.width.equalTo(recipeIngredientTextField.snp.height)
            $0.right.equalTo(recipeIngredientTextField).inset(10)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recipeIngredientTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(40)
        }
        
        decreaseButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
    }
}

//MARK: - Method(Rx Bind)
extension CreateRecipeView {
    
}

extension CreateRecipeView {
    
}

import SwiftUI
struct ForCreateRecipeView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CreateRecipeView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateRecipeView_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CreateRecipeViewController())
            .toPreview()
//        ForCreateRecipeView()
    }
}
