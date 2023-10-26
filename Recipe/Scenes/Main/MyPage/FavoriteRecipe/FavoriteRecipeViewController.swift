//
//  FavoriteRecipeViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class FavoriteRecipeViewController: BaseViewController {
    private var tableView = UITableView()
    private let disposeBag = DisposeBag()
    var data1: [RecipeInfo1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    init(data1: [RecipeInfo1]) {
        self.data1 = data1
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - Method(Normal)
extension FavoriteRecipeViewController {
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FavoriteRecipeViewCell.self, forCellReuseIdentifier: FavoriteRecipeViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        title = "저장 레시피"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
    }
}

extension FavoriteRecipeViewController: UITableViewDelegate, UITableViewDataSource, FavoriteRecipeViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteRecipeViewCell.reuseIdentifier, for: indexPath) as! FavoriteRecipeViewCell
        print(cell)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(data1[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func favoriteButtonTapped(_ cell: FavoriteRecipeViewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            let recipeId = data1[indexPath.row].recipe_id
            
            Task {
                let data: DeleteRecipeReuslt = try await NetworkManager.shared.fetch(.recipeUnSave("\(recipeId)"), parameters: ["recipe-id": recipeId])
                if data.data {
                    data1.remove(at: indexPath.row)
                    showToastSuccess(message: "저장이 해제됐습니다!")
                    self.tableView.reloadData()
                }
            }
        }
    }
}

/// Modal Sheet
extension FavoriteRecipeViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 184)
    }
}

extension FavoriteRecipeViewController: SheetDelegate {
    func forLogout() {
        print("")
    }
    
    func withdrawal() {
        print("")
    }
    
    func dismissSheetForDeleteReview(_ idx: Int) {
        print("")
    }
    
    func dismissSheetForUnSaveRecipe(_ idx: Int) {
        data1.remove(at: idx)
        showToastSuccess(message: "저장이 해제됐습니다!")
        self.tableView.reloadData()
    }
    
    func dismissSheetForDeleteRecipe(_ idx: Int) {
        print("")
    }
}
