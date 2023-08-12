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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteRecipeViewCell.reuseIdentifier, for: indexPath) as! FavoriteRecipeViewCell
        print(cell)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func favoriteButtonTapped(_ cell: FavoriteRecipeViewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            print("tapped!")
            ///Todo: 삭제 로직 서버연결
        }
    }
}
