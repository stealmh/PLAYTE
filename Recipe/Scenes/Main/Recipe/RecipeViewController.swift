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

    var disposeBag = DisposeBag()
    private let recipeView = RecipeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recipeView)
        recipeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        configureNavigationTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
}


extension RecipeViewController {
    func configureNavigationTabBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "recipe_logo", size: CGSize(width: 64, height: 14))
        navigationController?.navigationBar.barTintColor = .white
        let v = UILabel()
        v.text = "레시피"
        navigationItem.titleView = v

        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
    }

}
