//
//  RecipeDetailStepCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/23.
//

import UIKit
import SnapKit

struct RecipeDetailStep: Hashable {
    let id = UUID()
    let image: UIImage
    let title: String
    let contents: String
    let point: Bool
}

final class RecipeDetailStepCell: UICollectionViewCell {
    
    private let stepImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()
    
    private let stepTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        v.numberOfLines = 1
        return v
    }()
    
    private let stepContentsLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        v.numberOfLines = 0
        v.setContentHuggingPriority(.defaultHigh, for: .vertical)
        v.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
//        mockData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeDetailStepCell {
    func addView() {
        self.addSubViews(stepImageView, stepTitleLabel, stepContentsLabel)
    }
    func configureLayout() {
        stepImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.lessThanOrEqualTo(123)
        }
//        stepTitleLabel.backgroundColor = .red
        stepTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepImageView).offset(10)
            $0.left.equalTo(stepImageView.snp.right).offset(20)
            $0.right.equalToSuperview().inset(10)
            $0.height.greaterThanOrEqualTo(35)
        }
        
        stepContentsLabel.snp.makeConstraints {
            $0.left.right.equalTo(stepTitleLabel)
            $0.top.equalTo(stepTitleLabel.snp.bottom)
//            $0.height.greaterThanOrEqualToSuperview().dividedBy(4)
//            $0.height.equalTo(35)
            $0.height.greaterThanOrEqualTo(35)
        }
    }
    //for data inject
    func configure(_ item: RecipeDetailStages, idx: Int) {
        DispatchQueue.main.async {
            if let imageURL = item.stage_image_url {
                self.stepImageView.loadImage(from: imageURL)
            } else {
                self.stepImageView.image = UIImage(named: "noImage_svg")
            }
            self.stepTitleLabel.text = self.formatNumber(idx)
            self.stepContentsLabel.text = item.stage_description
        }
    }
    func mockData() {
        stepImageView.image = UIImage(named: "popcat")
        stepTitleLabel.text = "01 양파를 채 썰어서 준비해주세요"
        stepContentsLabel.text = "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요"
    }
    
    func formatNumber(_ number: Int) -> String {
        return String(format: "%02d", number)
    }
}

//MARK: - Method(Rx bind)
extension RecipeDetailStepCell {
    func bind() {}
}

#if DEBUG
import SwiftUI
struct ForRecipeDetailStepCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailStepCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeDetailStepCell_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailStepCell()
            .previewLayout(.fixed(width: 380, height: 123))
    }
}
#endif
