//
//  CommentTestViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/27.
//

import UIKit
import SnapKit

class CommentTestViewController: UIViewController {
    
    fileprivate let viewModel = CommentTestViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //        if let tableView = tableView {
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
        tableView.separatorStyle = .none
        //        }
    }
}

//MARK: - VC Preview
import SwiftUI
struct CommentTestViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentTestViewController()).toPreview()
    }
}
