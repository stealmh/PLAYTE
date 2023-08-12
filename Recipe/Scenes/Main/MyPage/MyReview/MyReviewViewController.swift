//
//  MyReviewViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class MyReviewViewController: BaseViewController {
    
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
extension MyReviewViewController {
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(MyReviewCell.self, forCellReuseIdentifier: MyReviewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        title = "내가 쓴 리뷰"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
    }
}

extension MyReviewViewController: UITableViewDelegate, UITableViewDataSource, MyReviewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewCell.reuseIdentifier, for: indexPath) as! MyReviewCell
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func deleteButtonTapped(_ cell: MyReviewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            print("tapped!")
            ///Todo: 삭제 로직 서버연결
            let customViewController = WriteRecipeSheetViewController()
            customViewController.modalPresentationStyle = .custom
            customViewController.transitioningDelegate = self

            present(customViewController, animated: true, completion: nil)
        }
    }
    
    func moveReviewButtonTapped(_ cell: MyReviewCell) {
        let vc = CommentTestViewController()
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
}

/// Modal Sheet
extension MyReviewViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 184)
    }
}
