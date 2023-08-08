//
//  RecipeViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RecipeViewController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    private let recipeView = RecipeView()
    var didSendEventClosure: ((RecipeViewController.Event) -> Void)?
    enum Event {
        case moveTorecipeDetail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        configureNavigationTabBar()
        bind()
        recipeView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
        recipeView.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipeView.delegate = self
    }
}

//MARK: - Method(Normal)
extension RecipeViewController {
    private func addView() {
        view.addSubViews(recipeView)
    }
    
    private func configureLayout() {
        recipeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationTabBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "recipe_logo", size: CGSize(width: 64, height: 14))
        navigationController?.navigationBar.barTintColor = .white
        let v = UILabel()
        v.text = "레시피"
        navigationItem.titleView = v
    }
}

//MARK: - Method(Rx Bind)
extension RecipeViewController {
    private func bind() {
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
    }
}

//MARK: - Method(레시피 셀 Delegate)
extension RecipeViewController: RecipeViewDelegate {
    func didTappedRecipeCell(item: Recipe) {
        let vc = RecipeDetailViewController()
        vc.configureData(item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - VC Preview
import SwiftUI
struct RecipeViewController_preview: PreviewProvider {
    static var previews: some View {
        RecipeViewController().toPreview()
    }
}
