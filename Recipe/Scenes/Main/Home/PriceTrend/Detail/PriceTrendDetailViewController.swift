//
//  PriceTrendDetailViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTrendDetailViewController: BaseViewController {
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "재료 이름을 검색해주세요."
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "magnifyingglass")!, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .gray
        return v
    }()
    
    private lazy var table = UITableView()
    var mockData = [PriceTrend]()
    var filteredData = [PriceTrend]()
    var filetered = false
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(searchTextField, searchImageButton, table)
        navigationBarSetting()
        configureLayout()
        setMockData()
        configureTableView()
        
        searchTextField.rx.text.orEmpty
            .skip(1)
            .subscribe(onNext: { data in
                self.filterText(data)
                if data.count > 0 {
                    self.searchImageButton.setImage(UIImage(systemName: "multiply.circle.fill")!, for: .normal)
                } else {
                    self.clearTextFieldSetting()
                }
            }).disposed(by: disposeBag)
        
        searchImageButton.rx.tap
            .subscribe(onNext: { _ in
                guard let data = self.searchTextField.text else { return }
                if data.count > 0 {
                    self.clearTextFieldSetting()
                }
            }).disposed(by: disposeBag)
    }

}

//MARK: - Method(normal)
extension PriceTrendDetailViewController {
    func navigationBarSetting() {
        navigationController?.navigationBar.barTintColor = .white
        
        let label = UILabel()
        label.textColor = .black
        label.text = "식재료 물가 추이"
        label.font = .boldSystemFont(ofSize: 24)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    func configureLayout() {
        searchTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextField).inset(7)
            $0.width.equalTo(searchTextField.snp.height)
            $0.right.equalTo(searchTextField).inset(10)
        }
        
        table.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - TableView 관련
extension PriceTrendDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 10
        table.clipsToBounds = true
        table.register(PriceTrendDetailCell.self, forCellReuseIdentifier: "PriceTrendDetailCell")
    }
    
    private func setMockData() {
        mockData.append(PriceTrend(title: "계란", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
        mockData.append(PriceTrend(title: "우유", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
        mockData.append(PriceTrend(title: "계란", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
        mockData.append(PriceTrend(title: "계란", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
        mockData.append(PriceTrend(title: "계란", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
        mockData.append(PriceTrend(title: "계란", tagName: "유제품", date: "05/13기준", transition: "+8원(0.4%)", count: 1, price: 214))
    }
    // 쿼리에 따른 필터링 진행 함수
    func filterText(_ query: String) {
        print(#function)
        print(query)
        // 중복 제거를 위해 클리어
        filteredData.removeAll()
        
        // data 배열 내 원소 순회
        for singleData in mockData {
            if singleData.title.contains(query) {
                filteredData.append(singleData)
            }
        }
        
        table.reloadData()
        filetered = true
        
    }
    
    func clearTextFieldSetting() {
        print(#function)
        self.searchTextField.text = ""
        self.searchImageButton.setImage(UIImage(systemName: "magnifyingglass")!, for: .normal)
        filteredData = []
        filetered = false
        table.reloadData()
    }
    
    // 섹션 내 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 필터링 된 데이터가 존재할 경우
        if !filteredData.isEmpty {
            return filteredData.count
        }
        
        // 그 외 필터가 진행된 경우에는 0, 아닌 경우에는 data 배열 길이 반환
        return filetered ? 0 : mockData.count
//        return mockData.count
    }
    
    // 셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceTrendDetailCell", for: indexPath) as! PriceTrendDetailCell
        if !filteredData.isEmpty {
            let filterData = filteredData[indexPath.row]
            cell.setData(data: filterData)
        } else {
            let mockData = mockData[indexPath.row]
            cell.setData(data: mockData)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
//MARK: - VC Preview
import SwiftUI
struct PriceTrendViewController_preview: PreviewProvider {
    static var previews: some View {
        PriceTrendDetailViewController().toPreview()
    }
}
