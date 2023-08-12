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

class WriteRecipeSheetViewController: BaseViewController {
    
    /// UI Properties
    private let sheetLine: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "sheet_svg")
        return v
    }()
    
    private let sheetTitle: UILabel = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(sheetLine, sheetTitle, deleteButton, cancelButton)
        view.layer.cornerRadius = 15
        configureLayout()
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
        UINavigationController(rootViewController: WriteRecipeSheetViewController())
            .toPreview()
            .previewLayout(.fixed(width: 393, height: 300))
            .ignoresSafeArea()
    }
}
