//
//  IngredientRegistrationViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/05.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class IngredientRegistrationViewController: BaseViewController {
    
    
    // UI
    private let sheetTitle: UILabel = {
        let v = UILabel()
        v.text = "식재료 등록"
        v.font = .boldSystemFont(ofSize: Constants.titleSize)
        return v
    }()
    
    private let cancelButton: UIButton = {
        let v = UIButton()
        v.setTitle("취소", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        return v
    }()
    
    private let sheetSubTitle: UILabel = {
        let v = UILabel()
        v.text = "재료 이름"
        v.font = .boldSystemFont(ofSize: Constants.subTitleSize)
        return v
    }()
    
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "재료 이름을 검색해주세요."
        v.layer.cornerRadius = Constants.mediumCorner
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
    
    private let coldRefrigeratorButton: UIButton = {
        let v = UIButton()
        v.setTitle("냉장/냉동", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let normalRefrigeratorButton: UIButton = {
        let v = UIButton()
        v.setTitle("실온", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    private let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("등록", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = Constants.smallCorner
        v.clipsToBounds = true
        return v
    }()
    
    private let checkArea: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    private lazy var table = UITableView()
    private let disposeBag = DisposeBag()
    //Property
    var data = [String]()
    var filteredData = [String]()
    var filetered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(sheetTitle,
                         cancelButton,
                         sheetSubTitle,
                         searchTextField,
                         coldRefrigeratorButton,
                         normalRefrigeratorButton,
                         registerButton,
                         searchImageButton,
                         table,
                         checkArea)
        configureLayout()
        configureTableView()
        setupData()
        searchTextField.rx.text.orEmpty
            .subscribe(onNext: { data in
                self.filterText(data)
                if data.count > 0 {
                    self.table.isHidden = false
                    self.searchImageButton.setImage(UIImage(systemName: "multiply.circle.fill")!, for: .normal)
                } else {
                    self.clearTextFieldSetting()
                }
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
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
extension IngredientRegistrationViewController {
    func configureLayout() {
        sheetTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        
        sheetSubTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(sheetTitle.snp.bottom).offset(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(sheetSubTitle.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextField).inset(7)
            $0.width.equalTo(searchTextField.snp.height)
            $0.right.equalTo(searchTextField).inset(10)
        }
        
        coldRefrigeratorButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.right.equalTo(view.snp.centerX).inset(10)
            $0.height.equalTo(searchTextField)
        }
        
        normalRefrigeratorButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.centerX).offset(10)
            $0.height.equalTo(searchTextField)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(normalRefrigeratorButton.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(searchTextField)
        }
        
        table.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(70)
        }
        
        checkArea.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(15)
            $0.top.equalTo(normalRefrigeratorButton.snp.bottom).offset(5)
            $0.bottom.equalTo(registerButton.snp.top).offset(5)
        }
    }
}

//MARK: - TableView 관련
extension IngredientRegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(MyCell.self, forCellReuseIdentifier: "MyCell")
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.mediumCorner
        table.clipsToBounds = true
    }
    
    private func setupData() {
        data.append("가지")
        data.append("가지볶음")
        data.append("볶음밥")
        data.append("김치찌개")
        data.append("두유")
    }
    // 쿼리에 따른 필터링 진행 함수
    func filterText(_ query: String) {
        print(query)
        // 중복 제거를 위해 클리어
        filteredData.removeAll()
        
        // data 배열 내 원소 순회
        for string in data {
            if string.contains(query) {
                filteredData.append(string)
            }
        }
        
        table.reloadData()
        filetered = true
        
    }
    
    func clearTextFieldSetting() {
        self.searchTextField.text = ""
        self.table.isHidden = true
        self.searchImageButton.setImage(UIImage(systemName: "magnifyingglass")!, for: .normal)
    }
    
    // 섹션 내 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 필터링 된 데이터가 존재할 경우
        if !filteredData.isEmpty {
            return filteredData.count
        }
        
        // 그 외 필터가 진행된 경우에는 0, 아닌 경우에는 data 배열 길이 반환
        return filetered ? 0 : data.count
    }
    
    // 셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        if !filteredData.isEmpty {
            cell.myLabel.text = filteredData[indexPath.row]
        } else {
            cell.myLabel.text = data[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///Todo: 태그 컬렉션에 추가기능 연동하기
        clearTextFieldSetting()
    }
}
//MARK: - Constants
extension IngredientRegistrationViewController {
    enum Constants {
        static let titleSize: CGFloat = 20
        static let subTitleSize: CGFloat = 18
        static let smallCorner: CGFloat = 5
        static let mediumCorner: CGFloat = 10
    }
}

//MARK: - VC Preview
import SwiftUI
struct IngredientRegistrationViewController_Preview: PreviewProvider {
    static var previews: some View {
        IngredientRegistrationViewController().toPreview()
    }
}
