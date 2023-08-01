//
//  CommentTestViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CommentTestViewController: UIViewController {
    
    fileprivate let viewModel = CommentTestViewModel()
    private let tableView = UITableView()
    private let commentBackground = UIView()
    
    private let textView: UITextView = {
        let v = UITextView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .gray.withAlphaComponent(0.1)
        v.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 40)
        return v
    }()
    
    private let placeholderLabel: UILabel = {
        let v = UILabel()
        v.text = "댓글을 적어보세요"
        v.textColor = .gray
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let applyRegisterButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "applyRegister"), for: .normal)
        return v
    }()
    
    private let applyingBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.backgroundColor = .mainColor?.withAlphaComponent(0.1)
        v.layer.borderColor = UIColor.mainColor?.cgColor
        v.layer.borderWidth = 1
        /// Todo: 얘도 키보드따라 움직이게 수정
        v.isHidden = true
        return v
    }()
    
    private let applyingLabel: UILabel = {
        let v = UILabel()
        v.text = "답글 남기는중..."
        v.textColor = .mainColor
        return v
    }()
    
    private let disposeBag = DisposeBag()
    private var textViewYValue = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(tableView)
        applyingBackground.addSubview(applyingLabel)
        commentBackground.addSubViews(textView, placeholderLabel, applyRegisterButton)
        view.addSubview(commentBackground)
        view.addSubview(applyingBackground)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
        commentBackground.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).inset(10)
            $0.left.equalTo(textView).inset(23)
        }
        
        applyRegisterButton.snp.makeConstraints {
            $0.top.equalTo(placeholderLabel)
            $0.right.bottom.equalToSuperview().inset(20)
        }
        
        applyingBackground.snp.makeConstraints {
            $0.bottom.equalTo(commentBackground.snp.top).inset(5)
            $0.centerX.equalTo(commentBackground)
            $0.height.equalTo(40)
            $0.width.equalTo(130)
        }
        
        applyingLabel.snp.makeConstraints {
            $0.center.equalTo(applyingBackground)
        }
        commentBackground.backgroundColor = .white
        
        keyboardCheck()

        viewModel.reloadSections = {(section: Int, indexpaths: [IndexPath], isInserting: Bool) in
            if isInserting {
                self.tableView.insertRows(at: indexpaths, with: .fade)
            } else {
                self.tableView.deleteRows(at: indexpaths, with: .fade)
            }
            self.tableView.beginUpdates()
            self.tableView.reloadSections([section], with: .fade)
            self.tableView.endUpdates()
        }
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 60
        tableView.register(CommentTestItemCell.self, forCellReuseIdentifier: CommentTestItemCell.identifier)
        tableView.register(CustomFirstTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CustomFirstTableViewHeaderFooterView")
        tableView.register(CommentFooterView.self, forHeaderFooterViewReuseIdentifier: "CommentFooterView")
        tableView.separatorStyle = .none
        //        }
    }
}

private extension CommentTestViewController {
    func keyboardCheck() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        print(#function)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textViewYValue == 0 {
                textViewYValue = self.commentBackground.frame.origin.y
            }
            print(keyboardSize.height)
            
            if self.commentBackground.frame.origin.y == textViewYValue {
                textViewYValue = self.commentBackground.frame.origin.y
                self.commentBackground.frame.origin.y -= keyboardSize.height - UIApplication.shared.windows.first!.safeAreaInsets.bottom - 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print(#function)
        if self.commentBackground.frame.origin.y != textViewYValue {
            self.commentBackground.frame.origin.y = textViewYValue
        }
    }
}

//MARK: - VC Preview
import SwiftUI
struct CommentTestViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentTestViewController()).toPreview()
    }
}
