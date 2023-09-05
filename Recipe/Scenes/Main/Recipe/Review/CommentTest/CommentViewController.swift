//
//  CommentViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CommentViewController: BaseViewController {
    
    lazy var viewModel = CommentViewModel(recipeComment: comment)
    private let tableView = UITableView()
    private let commentBackground: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.hexStringToUIColor(hex: "F0F0F0").cgColor
        v.layer.borderWidth = 1
        v.clipsToBounds = true
        v.backgroundColor = .white
        return v
    }()
    
    private let applyTitle: UILabel = {
        let v = UILabel()
        v.text = "댓글 10"
        v.font = .boldSystemFont(ofSize: 16)
        v.textColor = .mainColor
        v.asColor(targetString: "댓글", color: .black)
        return v
    }()
    
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
    var comment: RecipeComment
    
    /// 사실상 숏폼 아이디로 사용중이다..
    var divideId: Int
    var recipdId: Int?
    var hashTagInfo: (String, Int)?
    var hashTagInfoForChild: (String,Int,Int,Int)?
    
    init(comment: RecipeComment, divideId: Int) {
        self.comment = comment
        self.divideId = divideId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(applyTitle)
        view.addSubViews(tableView)
        applyingBackground.addSubview(applyingLabel)
        commentBackground.addSubViews(textView, placeholderLabel, applyRegisterButton)
        view.addSubview(commentBackground)
        view.addSubview(applyingBackground)
        applyTitle.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(16)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(applyTitle.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
        }
        //        tableView.backgroundColor = .blue
        //        commentBackground.backgroundColor = .red
        commentBackground.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
            $0.bottom.equalTo(commentBackground.snp.top).offset(-10)
            $0.centerX.equalTo(commentBackground)
            $0.height.equalTo(40)
            $0.width.equalTo(130)
        }
        
        applyingLabel.snp.makeConstraints {
            $0.center.equalTo(applyingBackground)
        }
        //        commentBackground.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
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
        
        viewModel.reportRelay.subscribe(onNext: {(id, section) in
            Task {
                let result = await self.viewModel.reportComment(id: id)
                if result {
                    print("삭제된 데이터는? -> \(self.comment.data.content[section])")
                    self.comment.data.content.remove(at: section)
//                    self.viewModel.reloadData.accept(self.comment)
                    self.showToastSuccess(message: "신고가 접수되었습니다.")
                    sleep(1)
                    self.dismiss(animated: true)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.reportForChildRelay.subscribe(onNext: {(id, index, section) in
            Task {
                let result = await self.viewModel.reportCommentReply(id: id)
                if result {
                    print("삭제 될 데이터는? -> \(self.comment.data.content[section].replyList[index])")
                    self.comment.data.content[section].replyList.remove(at: index)
                    self.viewModel.reloadData.accept(self.comment)
                    self.showToastSuccess(message: "신고가 접수되었습니다.")
                }
            }
        }).disposed(by: disposeBag)
        
        
        
        viewModel.replyRelay.subscribe(onNext: { (nickName, id) in
            print("!!!!")
            self.hashTagInfo = (nickName, id)
            self.textView.text = "@\(nickName) "
            self.textView.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        viewModel.replyForChildRelay.subscribe(onNext: { (nickName,id,index,section) in
            print("!!!!")
            let parentID = self.comment.data.content[section].comment_id
            self.hashTagInfo = (nickName, parentID)
            self.textView.text = "@\(nickName) "
            self.textView.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        
        
        viewModel.likeRelay.subscribe(onNext: { (id, section) in
            Task {
                // Check[1] 사용자의 좋아요 여부를 확인
                print("데이터가 맞는지 체크:", self.comment.data.content[section].is_liked)
                /// 이미 좋아요를 누른 상태라면? -> 취소하는 요청
                if self.comment.data.content[section].is_liked {
                    let result = await self.viewModel.unlikeComment(id: id)
                    if result {
                        self.comment.data.content[section].comment_likes -= 1
                        self.comment.data.content[section].is_liked = false
                        print("데이터가 수정되었는지 체크:", self.comment.data.content[section].is_liked)
                        self.viewModel.reloadData.accept(self.comment)
                    }
                    
                }
                /// 좋아요를 누르지 않은 상태라면? -> 수락 하는 요청
                else {
                    let result = await self.viewModel.likeComment(id: id)
                    if result {
                        self.comment.data.content[section].comment_likes += 1
                        self.comment.data.content[section].is_liked = true
                        print("데이터가 수정되었는지 체크:", self.comment.data.content[section].is_liked)
                        self.viewModel.reloadData.accept(self.comment)
                    }
                    
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.likeForChildRelay.subscribe(onNext: { (id, index, section) in
            Task {
                // Check[1] 사용자의 좋아요 여부를 확인
                print("데이터가 맞는지 체크:", self.comment.data.content[section].replyList[index].is_likes)
                let check = self.comment.data.content[section].replyList[index].reply_id
                print("Check:\(check), id: \(id)")
                
                if self.comment.data.content[section].replyList[index].is_likes {
                    LoginService.shared.sendRequest(url: NetworkEndpoint.shortformCommentReplyUnLike("\(id)").url,method: .get) { (data: DefaultReturnBool) in
                        if data.data {
                            self.comment.data.content[section].replyList[index].reply_likes -= 1
                            self.comment.data.content[section].replyList[index].is_likes = false
                            print("데이터가 수정되었는지 체크:", self.comment.data.content[section].replyList[index].is_likes)
                            self.viewModel.reloadData.accept(self.comment)
                        }
                    }
                }

                
                /// 이미 좋아요를 누른 상태라면? -> 취소하는 요청
//                if self.comment.data.content[section].replyList[index].is_likes {
//                    let result = await self.viewModel.unlikeCommentReply(id: id)
//                    if result {
//                        self.comment.data.content[section].replyList[index].reply_likes -= 1
//                        self.comment.data.content[section].replyList[index].is_likes = false
//                        print("데이터가 수정되었는지 체크:", self.comment.data.content[section].replyList[index].is_likes)
//                        self.viewModel.reloadData.accept(self.comment)
//                    }
//                    
//                }
                /// 좋아요를 누르지 않은 상태라면? -> 수락 하는 요청
                else {
                    LoginService.shared.sendRequest(url: NetworkEndpoint.shortformCommentReplyLike("\(id)").url,method: .get) { (data: DefaultReturnBool) in
                        if data.data {
                            self.comment.data.content[section].replyList[index].reply_likes += 1
                            self.comment.data.content[section].replyList[index].is_likes = true
                            print("데이터가 수정되었는지 체크:", self.comment.data.content[section].replyList[index].is_likes)
                            self.viewModel.reloadData.accept(self.comment)
                        }
                    }
                    
                    
                    
//                    
//                    let result = await self.viewModel.likeCommentReply(id: id)
//                    if result {
//                        self.comment.data.content[section].replyList[index].reply_likes += 1
//                        self.comment.data.content[section].replyList[index].is_likes = true
//                        print("데이터가 수정되었는지 체크:", self.comment.data.content[section].replyList[index].is_likes)
//                        self.viewModel.reloadData.accept(self.comment)
//                    }
                    
                }
            }
        }).disposed(by: disposeBag)
        
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 60
        tableView.register(CommentItemCell.self, forCellReuseIdentifier: CommentItemCell.identifier)
        tableView.register(CustomFirstTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CustomFirstTableViewHeaderFooterView")
        tableView.register(CommentFooterView.self, forHeaderFooterViewReuseIdentifier: "CommentFooterView")
        tableView.separatorStyle = .none
        //        }
        DispatchQueue.main.async {
            self.applyTitle.text = "댓글 \(self.comment.data.content.count)"
            self.applyTitle.asColor(targetString: "댓글", color: .grayScale5 ?? .black)
        }
        
        textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        applyRegisterButton.rx.tap
            .subscribe(onNext: { _ in
                if let text = self.textView.text, text.contains("@"), let info = self.hashTagInfo {
                        let id = info.1
                        let parameter: [String: Any] = ["content": text]
                        Task {
                            let data = await self.viewModel.registerCommentReply(id: id, parameter: parameter)
                            if data {
                                Task {
                                    let data: RecipeComment = try await NetworkManager.shared.get(.shortformComment("\(self.divideId)"))
                                    self.comment = data
                                    self.viewModel.reloadData.accept(self.comment)
                                }
                                DispatchQueue.main.async {
                                    self.applyTitle.text = "댓글 \(self.comment.data.content.count)"
                                    self.applyTitle.asColor(targetString: "댓글", color: .grayScale5 ?? .black)
                                }
                                self.textView.resignFirstResponder()
                                self.textView.text = ""
                                self.hashTagInfo = nil
                            }
                        }
                } else {
                    Task {
                        if let text = self.textView.text {
                            LoginService.shared.sendComment(comment: text, id: self.divideId) { data in
                                if data.code == "SUCCESS" {
                                    Task {
                                        let data: RecipeComment = try await NetworkManager.shared.get(.shortformComment("\(self.divideId)"))
                                        self.comment = data
                                        self.viewModel.reloadData.accept(self.comment)
                                    }
                                    DispatchQueue.main.async {
                                        self.applyTitle.text = "댓글 \(self.comment.data.content.count)"
                                        self.applyTitle.asColor(targetString: "댓글", color: .grayScale5 ?? .black)
                                    }
                                    self.textView.resignFirstResponder()
                                    self.textView.text = ""
                                }
                            }
                        }
                        
                    }
                    
                }
            }).disposed(by: disposeBag)
    }
}

private extension CommentViewController {
    func keyboardCheck() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        print(#function)
        DispatchQueue.main.async {
            self.applyingBackground.isHidden = false
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            let spacing: CGFloat = 10
            
            let adjustmentHeight = keyboardHeight - safeAreaBottom + spacing
            
            self.commentBackground.transform = CGAffineTransform(translationX: 0, y: -adjustmentHeight)
            self.applyingBackground.transform = CGAffineTransform(translationX: 0, y: -adjustmentHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print(#function)
        self.commentBackground.transform = .identity
        self.applyingBackground.transform = .identity
        DispatchQueue.main.async {
            self.applyingBackground.isHidden = true
        }
    }
}

//MARK: - VC Preview
import SwiftUI
struct CommentViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentViewController(comment: RecipeComment(code: "", data: CommentContents(content: [CommentInfo(comment_content: "컨텐츠입니다.", comment_id: 0, comment_likes: 10, comment_writtenby: "미노", created_at: "2023-03-16", is_liked: false, replyList: [ReplyList(created_at: "2023-03-16", is_likes: true, reply_content: "리플 컨텐츠입니다", reply_id: 2, reply_likes: 0, reply_writtenby: "미노리플")])])), divideId: 0)).toPreview()
    }
}
