//
//  WriteRecipeViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class WriteRecipeViewController: BaseViewController {
    
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
extension WriteRecipeViewController {
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(WriteRecipeViewCell.self, forCellReuseIdentifier: WriteRecipeViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        title = "작성 레시피"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
    }
}

extension WriteRecipeViewController: UITableViewDelegate, UITableViewDataSource, WriteRecipeViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WriteRecipeViewCell.reuseIdentifier, for: indexPath) as! WriteRecipeViewCell
        print(cell)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(data1[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func deleteButtonTapped(_ cell: WriteRecipeViewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            let recipeId = data1[indexPath.row].recipe_id
            print(recipeId)
            ///Todo: 삭제 로직 서버연결
            let customViewController = WriteRecipeSheetViewController(recipeId: recipeId, idx: indexPath.row, startPoint: .writeRecipe)
            customViewController.delegate = self
            customViewController.modalPresentationStyle = .custom
            customViewController.transitioningDelegate = self

            present(customViewController, animated: true, completion: nil)
        }
    }
}

/// Modal Sheet
extension WriteRecipeViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 184)
    }
}

extension WriteRecipeViewController: SheetDelegate {
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
        print("")
    }
    
    func dismissSheetForDeleteRecipe(_ idx: Int) {
        data1.remove(at: idx)
        self.tableView.reloadData()
    }
}
