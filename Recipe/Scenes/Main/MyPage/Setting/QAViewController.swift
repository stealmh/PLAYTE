//
//  QAViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class QAViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    let questions = ["계정 탈퇴가 안될 때는 어떻게 해야 하나요?",
                     "내가 작성한 리뷰를 수정하고 싶어요.",
                     "내 레시피 작성 시, 단계 조절은 어떻게 해야 할까요?"]
    let answers = ["A. 계정 탈퇴는 마이페이지>설정>회원탈퇴를 통해 이루어집니다. 해당 방법으로 재시도 한 경우에도 계정 탈퇴 방법을 찾지 못한 경우 고객센터로 연락 바랍니다.",
                   "A. 내가 작성한 리뷰는 마이페이지>내가 쓴 리뷰에 들어가면 수정 및 삭제가 가능합니다. ",
                   "A. 레시피 작성 페이지에서 조리단계를 작성하는 위치 오른쪽의 직선 아이콘을 3초 이상 누르게 되면 상하이동이 가능합니다. 원하는 레시피의 내용을 작성 후 위의 방법으로 단계를 조절할 수 있습니다. "]
    private let disposeBag = DisposeBag()
    var expandedSections: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.reuseIdentifier)
        self.view.addSubview(tableView)
        
        expandedSections = Array(repeating: false, count: questions.count)
        title = "Q&A"
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .gray)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections[section] ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.reuseIdentifier, for: indexPath) as! AnswerCell
//        cell.guideLabel.text = answers[indexPath.section]
        cell.configureTextSpacing(answers[indexPath.section])
        cell.guideLabel.asColor(targetString: "A", color: .mainColor ?? .orange)
        cell.section = indexPath.section
        cell.closeButton.rx.tap
            .subscribe(onNext: { _ in
                print("tapped")
                if let section = cell.section {
                    self.expandedSections[section] = false
                    tableView.reloadSections([section], with: .fade)
                }
            }).disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 11, width: tableView.frame.width - 30, height: 22))
        titleLabel.text = "Q. \(questions[section])"
        titleLabel.asColor(targetString: "Q", color: .mainColor ?? .orange)
        headerView.addSubview(titleLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleSection(_:)))
        headerView.tag = section
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }

    @objc func toggleSection(_ gesture: UITapGestureRecognizer) {
        guard let section = gesture.view?.tag else { return }
        expandedSections[section].toggle()
        tableView.reloadSections([section], with: .none)
    }
}
