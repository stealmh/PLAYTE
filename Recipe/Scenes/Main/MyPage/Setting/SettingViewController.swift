//
//  SettingViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class SettingViewController: BaseViewController {
    
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
        return 6
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
    case notice
    case qna
    case terms
    case logout
    case withdrawal

    var title: String {
        switch self {
        case .nickname:
            return "닉네임 관리"
        case .notice:
            return "공지사항"
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
        return self == .nickname ? "냉파쿵야" : nil
    }
}
