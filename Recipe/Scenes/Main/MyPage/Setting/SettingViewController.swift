//
//  SettingViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift
import PDFKit

class SettingViewController: BaseViewController {
    
    var didSendEventClosure: ((SettingViewController.Event) -> Void)?
    enum Event {
        case withdrawal
    }
    private var tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: - Method(Normal)
extension SettingViewController {
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        title = "설정"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.reuseIdentifier, for: indexPath) as! SettingViewCell
        cell.selectionStyle = .none
        
        guard let itemType = SettingItemType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(itemType.title, itemType.nickname)
        
        if itemType.isLogout {
            cell.configureLogout()
        } else if itemType.isWithdrawal {
            cell.configureWithdrawal()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemType = SettingItemType(rawValue: indexPath.row) else { return }
        switch itemType {
        case .nickname:
            let vc = NickNameChangeViewController()
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
            //        case .notice:
            //            let vc = AnnouncementViewController()
            //            self.tabBarController?.tabBar.isHidden = true
            //            navigationController?.pushViewController(vc, animated: true)
        case .qna:
            let vc = QAViewController()
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        case .terms:
            let vc = TermsViewController()
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        case .withdrawal:
            let customViewController = WriteRecipeSheetViewController(recipeId: 0, idx: 0, startPoint: .withdraw)
            customViewController.sheetTitle.text = "정말 탈퇴하시겠습니까?"
            customViewController.delegate = self
            customViewController.modalPresentationStyle = .custom
            customViewController.transitioningDelegate = self
            
            present(customViewController, animated: true, completion: nil)
            
            
            //            NetworkManager.shared.performRequest(endpoint: .withdrawal, responseType: Withdrawal.self) { result in
            //                switch result {
            //                case .success(let data):
            //                    print("==  data ==: ", data)
            //                    if data.code == "SUCCESS" || data.message == "성공" {
            //                        self.didSendEventClosure?(.withdrawal)
            //                    } else {
            //                        print("error")
            //                    }
            //                case .failure(let error):
            //                    print("error")
            //                }
            //            }
        case .logout:
            let customViewController = WriteRecipeSheetViewController(recipeId: 0, idx: 0, startPoint: .logout)
            customViewController.sheetTitle.text = "로그아웃 하시겠습니까?"
            customViewController.delegate = self
            customViewController.modalPresentationStyle = .custom
            customViewController.transitioningDelegate = self
            
            present(customViewController, animated: true, completion: nil)
            //            NetworkManager.shared.performRequest(endpoint: .logout, responseType: Withdrawal.self) { result in
            //                switch result {
            //                case .success(let data):
            //                    print("==  data ==: ", data)
            //                    if data.code == "SUCCESS" || data.message == "성공" {
            //                        self.didSendEventClosure?(.withdrawal)
            //                    } else {
            //                        print("error")
            //                    }
            //                case .failure(let error):
            //                    print("error")
            //                }
            //            }
        default: return
        }
    }
    
}

extension SettingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 184)
    }
}

extension SettingViewController: SheetDelegate {
    func dismissSheetForDeleteRecipe(_ idx: Int) {
        print("")
    }
    
    func dismissSheetForUnSaveRecipe(_ idx: Int) {
        print("")
    }
    
    func dismissSheetForDeleteReview(_ idx: Int) {
        print("")
    }
    
    func forLogout() {
        NetworkManager.shared.performRequest(endpoint: .logout, responseType: Withdrawal.self) { result in
            switch result {
            case .success(let data):
                print("==  data ==: ", data)
                if data.code == "SUCCESS" || data.message == "성공" {
                    KeyChain.shared.delete(account: .accessToken)
                    KeyChain.shared.delete(account: .refreshToken)
                    KeyChain.shared.delete(account: .idToken)
                    KeyChain.shared.delete(account: .loginType)
                    self.didSendEventClosure?(.withdrawal)
                } else {
                    print("error")
                }
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func withdrawal() {
        NetworkManager.shared.performRequest(endpoint: .withdrawal, responseType: Withdrawal.self) { result in
            switch result {
            case .success(let data):
                print("==  data ==: ", data)
                if data.code == "SUCCESS" || data.message == "성공" {
                    self.didSendEventClosure?(.withdrawal)
                } else {
                    print("error")
                }
            case .failure(let error):
                print("error")
            }
        }
    }
    
    
}


//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct SettingViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: SettingViewController())
            .toPreview()
    }
}

enum SettingItemType: Int {
    case nickname
    //    case notice
    case qna
    case terms
    case logout
    case withdrawal
    
    var title: String {
        switch self {
        case .nickname:
            return "닉네임 관리"
            //        case .notice:
            //            return "공지사항"
        case .qna:
            return "Q&A"
        case .terms:
            return "이용약관"
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "회원탈퇴"
        }
    }
    
    var isLogout: Bool {
        return self == .logout
    }
    
    var isWithdrawal: Bool {
        return self == .withdrawal
    }
    
    var nickname: String? {
        return self == .nickname ? "" : nil
    }
}
