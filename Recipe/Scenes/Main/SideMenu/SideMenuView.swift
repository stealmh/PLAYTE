//
//  SideMenuView.swift
//  Recipe
//
//  Created by 김민호 on 2023/10/24.
//

import UIKit
import SnapKit

protocol SideMenuDelegate: AnyObject {
    func didTappedBackButton()
    func didTappedReadAllButton()
    func didTappedCell()
}

final class SideMenuView: UIView {
    
    
    //1. 뒤로가기 버튼 한개
    //2. 알림이미지 (알림있을때 / 없을때 이미지 다름)
    //3. 알림타이틀
    //4. 전체읽기
    //5. 알림 리스트들 (table view)
    
    private let backButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "backbuttongray_svg"), for: .normal)
        return v
    }()
    
    private let alertImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "bell.default_svg")
        return v
    }()
    
    private let alertLabel: UILabel = {
        let v = UILabel()
        v.text = "알림"
        v.textColor = .grayScale6
        v.font = .boldSystemFont(ofSize: 16)
        return v
    }()
    
    private let readAllButton: UIButton = {
        let v = UIButton()
        v.setTitle("전체 읽기", for: .normal)
        v.setTitleColor(.grayScale4, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let tableView = UITableView()
    
    weak var delegate: SideMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews(backButton, alertImageView, alertLabel, readAllButton, tableView)
        configureLayout()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("RegisterView deinit")
    }
}

extension SideMenuView {
    private func configureLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(57)
            $0.left.equalToSuperview().offset(14)
            $0.width.height.equalTo(24)
        }
        
        alertImageView.snp.makeConstraints {
            $0.top.width.height.equalTo(backButton)
            $0.left.equalTo(backButton.snp.right).offset(4)
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(backButton)
            $0.left.equalTo(alertImageView.snp.right).offset(9)
            $0.width.equalTo(28)
            $0.height.equalTo(19)
        }
        
        readAllButton.snp.makeConstraints {
            $0.centerY.equalTo(alertLabel)
            $0.width.equalTo(62)
            $0.height.equalTo(17)
            $0.right.equalToSuperview().inset(21)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Method(TableView)
extension SideMenuView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as! SideMenuCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK: - Preview
#if DEBUG
import SwiftUI
struct ForSideMenuView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        SideMenuView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct SideMenuView_Preview: PreviewProvider {
    static var previews: some View {
        ForSideMenuView()
                    .previewLayout(.fixed(width: 333, height: 600))
    }
}
#endif
