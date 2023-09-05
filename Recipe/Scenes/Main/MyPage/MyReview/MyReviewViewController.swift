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
    private let viewModel = MyReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        
        viewModel.myReviewRelay.subscribe(onNext: { data in
            print("== myReviewRelay 연결됨 ==")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        Task {
            await viewModel.getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        Task {
//            await viewModel.getData()
//        }
//    }
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
        return viewModel.myReviewRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewCell.reuseIdentifier, for: indexPath) as! MyReviewCell
        cell.delegate = self
        cell.selectionStyle = .none
//        if let myReview = viewModel.myReview {
//            cell.configure(myReview.data[indexPath.row])
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
        cell.configure(viewModel.myReviewRelay.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func deleteButtonTapped(_ cell: MyReviewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            print("tapped!")
            print(indexPath.row)
            print(self.viewModel.myReviewRelay.value)
            let reviewID = self.viewModel.myReviewRelay.value[indexPath.row].review_id
            ///Todo: 삭제 로직 서버연결
            let customViewController = WriteRecipeSheetViewController(recipeId: reviewID, idx: indexPath.row, startPoint: .myReview)
            customViewController.delegate = self
            customViewController.modalPresentationStyle = .custom
            customViewController.transitioningDelegate = self

            present(customViewController, animated: true, completion: nil)
        }
    }
    
    func moveReviewButtonTapped(_ cell: MyReviewCell) {
        let vc = CommentViewController(comment: RecipeComment(code: "", data: CommentContents(content: [CommentInfo(comment_content: "컨텐츠입니다.", comment_id: 0, comment_likes: 10, comment_writtenby: "미노", created_at: "2023-03-16", is_liked: false, replyList: [ReplyList(created_at: "2023-03-16", is_likes: false, reply_content: "리플 컨텐츠입니다", reply_id: 2, reply_likes: 0, reply_writtenby: "미노리플")])])), divideId: 0)
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

extension MyReviewViewController: SheetDelegate {
    func forLogout() {
        print("")
    }
    
    func withdrawal() {
        print("")
    }
    
    func dismissSheetForDeleteReview(_ idx: Int) {
        var current = viewModel.myReviewRelay.value
        current.remove(at: idx)
        viewModel.myReviewRelay.accept(current)
        showToastSuccess(message: "작성한 리뷰가 삭제되었습니다.")
        self.tableView.reloadData()
    }
    
    func dismissSheetForUnSaveRecipe(_ idx: Int) {
        print("")
    }
    
    func dismissSheetForDeleteRecipe(_ idx: Int) {
        print("")
    }
}
