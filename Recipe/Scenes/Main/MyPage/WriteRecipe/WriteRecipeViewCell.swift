//
//  WriteRecipeViewCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct WriteRecipe: Hashable {
    let id = UUID()
    let image: UIImage
    let uploadTime: String
    let title: String
    let cookTime: String
    let rate: String
}

protocol WriteRecipeViewCellDelegate: AnyObject {
    func deleteButtonTapped(_ cell: WriteRecipeViewCell)
}

final class WriteRecipeViewCell: UITableViewCell {
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    private let recipeTitle: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        v.textColor = .black
        
        return v
    }()
    
    let deleteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "delete_svg"), for: .normal)
        return v
    }()
    private let cookTimeLabel: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "time_svg"), for: .normal)
        v.setTitleColor(.grayScale4, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .left
        return v
    }()
    
    private let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .grayScale4
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    private let divideLine: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.grayScale4?.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    private let nickName: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale4
        return v
    }()
    private let rate: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "star_svg"), for: .normal)
        v.setTitleColor(.mainColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .left
        return v
    }()
    
    private let circleBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 10
        v.layer.cornerRadius = 20
        return v
    }()
    
    let disposeBag = DisposeBag()
    weak var delegate: WriteRecipeViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubViews(recipeImageView,
                    recipeTitle, cookTimeLabel, uploadTimeLabel, divideLine, rate)
        contentView.addSubview(deleteButton)
        self.configureLayout()
        mockData()
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.deleteButtonTapped(self)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension WriteRecipeViewCell {
    
    func configureLayout() {
        recipeImageView.snp.makeConstraints {
//            $0.left.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.left.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(5)
        }

        uploadTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(recipeImageView.snp.right).offset(20)
            $0.height.equalTo(17)
            $0.width.greaterThanOrEqualTo(35)
        }

        recipeTitle.snp.makeConstraints {
            $0.top.equalTo(uploadTimeLabel.snp.bottom).offset(10)
            $0.left.equalTo(uploadTimeLabel)
            $0.width.equalTo(200)
            $0.height.equalTo(19)
        }

        rate.snp.makeConstraints {
            $0.top.equalTo(recipeTitle.snp.bottom).offset(10)
            $0.left.equalTo(uploadTimeLabel)
            $0.height.equalTo(20)
            $0.width.greaterThanOrEqualTo(74)
        }
        
        cookTimeLabel.snp.makeConstraints {
            $0.top.height.width.equalTo(rate)
            $0.left.equalTo(rate.snp.right).offset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(recipeTitle)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
    }
    
    func mockData() {
        recipeImageView.image = UIImage(named: "popcat")
        recipeTitle.text = "토마토 계란 볶음밥"
        cookTimeLabel.setTitle("10분", for: .normal)
        uploadTimeLabel.text = "2023/02/22"
        rate.setTitle("4.7(104)", for: .normal)
        nickName.text = "규땡뿡야"
    }
    
    func configure(_ data: WriteRecipe) {
        recipeImageView.image = data.image
        uploadTimeLabel.text = data.uploadTime
        rate.setTitle(data.rate, for: .normal)
        recipeTitle.text = data.title
        cookTimeLabel.setTitle(data.cookTime, for: .normal)

    }
}

#if DEBUG
import SwiftUI
struct ForWriteRecipeViewCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        WriteRecipeViewCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct WriteRecipeViewCell_Preview: PreviewProvider {
    static var previews: some View {
        ForWriteRecipeViewCell()
            .previewLayout(.fixed(width: 380, height: 100))
    }
}
#endif

