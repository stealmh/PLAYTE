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
    var viewModel = RecipeViewModel()
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
        super.viewDidDisappear(animated)
        recipeView.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recipeView.delegate = self
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        recipeView.viewModel = viewModel
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

        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(imageName: "bell.default_svg", size: CGSize(width: 50, height: 40))
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "recipe", size: CGSize(width: 110, height: 40))
        navigationController?.navigationBar.barTintColor = .white
    }
}

//MARK: - Method(Rx Bind)
extension RecipeViewController {
    private func bind() {
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
        
        recipeView.searchImageButton.rx.tap
            .subscribe(onNext: { _ in
                print("tapped")
                let vc = RecipeSearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }).disposed(by: disposeBag)
    }
}

//MARK: - Method(레시피 셀 Delegate)
extension RecipeViewController: RecipeViewDelegate {
    func didTappedSortButton(_ tag: Int) {
        
    }
    
    func didTappedRecipeCell(item: RecipeInfo) {
        let vc = RecipeDetailViewController()
//        vc.configureData(item)
        vc.recipeInfo = item
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - VC Preview
import SwiftUI
struct RecipeViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: RecipeViewController())
            .toPreview()
            .ignoresSafeArea()
    }
}
