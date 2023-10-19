//
//  WriteRecipeSheetViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


struct DeleteRecipeReuslt: Codable {
    let code: String
    let data: Bool
    let message: String
    
}

protocol SheetDelegate: AnyObject {
    func dismissSheetForDeleteRecipe(_ idx: Int)
    func dismissSheetForUnSaveRecipe(_ idx: Int)
    func dismissSheetForDeleteReview(_ idx: Int)
    func forLogout()
    func withdrawal()
}

class WriteRecipeSheetViewController: BaseViewController {
    
    enum SheetStartPoint {
        case saveRecipe
        case writeRecipe
        case myReview
        case logout
        case withdraw
    }
    
    /// UI Properties
    private let sheetLine: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "sheet_svg")
        return v
    }()
    
    let sheetTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20)
        v.textColor = .grayScale5
        v.text = "삭제하시겠습니까?"
        return v
    }()
    
    private let deleteButton: UIButton = {
        let v = UIButton()
        v.setTitle("예", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .mainColor
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let cancelButton: UIButton = {
        let v = UIButton()
        v.setTitle("아니요", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 10
        return v
    }()
    
    /// Properties
    private let disposeBag = DisposeBag()
    weak var delegate: SheetDelegate?
    var recipeId: Int
    var idx: Int
    var startPoint: SheetStartPoint
    
    init(recipeId: Int, idx: Int, startPoint: SheetStartPoint) {
        self.recipeId = recipeId
        self.idx = idx
        self.startPoint = startPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(sheetLine, sheetTitle, deleteButton, cancelButton)
        view.layer.cornerRadius = 15
        configureLayout()
        
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                print("startPoint::", self.startPoint)
                Task {
                    switch self.startPoint {
                    case .myReview:
                        let data: DeleteRecipeReuslt = try await NetworkManager.shared.get(.deleteReview("\(self.recipeId)"))
                        
                        if data.data {
                            self.delegate?.dismissSheetForDeleteReview(self.idx)
                            self.dismiss(animated: true)
                        }
                    case .saveRecipe:
                        let data: DeleteRecipeReuslt = try await NetworkManager.shared.fetch(.recipeUnSave("\(self.recipeId)"), parameters: ["recipe-id": self.recipeId])
                        if data.data {
                            RecipeCoreDataHelper.shared.deleteRecipe(byID: self.recipeId)
                            self.delegate?.dismissSheetForUnSaveRecipe(self.recipeId)
                            self.dismiss(animated: true)
                        }
                    case .writeRecipe:
                        let data: DeleteRecipeReuslt = try await NetworkManager.shared.fetch(.deleteMyRecipe("\(self.recipeId)"), parameters: ["shortform-recipe-id": self.recipeId])
                        if data.data {
                            self.delegate?.dismissSheetForDeleteRecipe(self.idx)
                            RecipeCoreDataHelper.shared.deleteRecipe(byID: self.idx)
                            self.dismiss(animated: true)
                        }
                    case .logout:
                        self.delegate?.forLogout()
                        self.dismiss(animated: true)
                    case .withdraw:
                        self.delegate?.withdrawal()
                        self.dismiss(animated: true)
                    default: return
                    }
                }
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension WriteRecipeSheetViewController {
    func configureLayout() {
        
        sheetLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
            $0.width.equalTo(59)
            $0.height.equalTo(6)
        }
        
        sheetTitle.snp.makeConstraints {
            $0.top.equalTo(sheetLine.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(sheetTitle.snp.bottom).offset(25)
            $0.left.equalTo(view.snp.centerX).offset(10)
            $0.width.equalTo(170)
            $0.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.width.height.equalTo(deleteButton)
            $0.right.equalTo(view.snp.centerX).offset(-10)
            
        }
    }
}

//MARK: - VC Preview
import SwiftUI
import AVKit
struct WriteRecipeSheetViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: WriteRecipeSheetViewController(recipeId: 0, idx: 0, startPoint: .writeRecipe))
            .toPreview()
            .previewLayout(.fixed(width: 393, height: 300))
            .ignoresSafeArea()
    }
}
