//
//  DefaultTextFieldCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol DefaultTextFieldCellDelegate: AnyObject {
    func didTappedCell(_ item: IngredientInfo)
}

final class DefaultTextFieldCell: UICollectionViewCell {
    
    ///UI Properties
    let recipeNametextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "placeholder"
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    private let table = UITableView()
    
    ///Properties
    private let disposeBag = DisposeBag()
    weak var delegate: DefaultTextFieldCellDelegate?
    var filteredData = [IngredientInfo]()
    var data = [IngredientInfo]()
    var filetered = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupView()
        bind()
        configureTableView()
        table.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension DefaultTextFieldCell {
    
    private func addViews() {
        addSubViews(recipeNametextField, table)
    }
    private func setupView() {
        recipeNametextField.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(50)
        }
        
        table.snp.makeConstraints {
            $0.top.equalTo(recipeNametextField.snp.bottom).offset(5)
            $0.left.right.equalTo(recipeNametextField).inset(10)
            $0.height.greaterThanOrEqualTo(70)
//            $0.edges.equalTo(recipeNametextField)
        }
    }
    
    func configure(text: String) {
        recipeNametextField.placeholder = text
    }
    
    func filterText(_ query: String) {
        print(query)
        // 중복 제거를 위해 클리어
        filteredData.removeAll()
        
        // data 배열 내 원소 순회
        for string in data {
            if string.ingredient_name.contains(query) {
                filteredData.append(string)
            }
        }
        
        table.reloadData()
        filetered = true
        
    }
    
    func clearTextFieldSetting() {
        self.recipeNametextField.text = ""
        self.table.isHidden = true
//        self.searchImageButton.setImage(UIImage(systemName: "magnifyingglass")!, for: .normal)
    }
    
    func confifgure(_ item: Ingredient) {
        print(#function)
        self.data = item.data
    }
}

//MARK: - Method(Rx Bind)
extension DefaultTextFieldCell {
    func bind() {
        recipeNametextField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.filterText(data)
                if data.count > 0 {
                    self.table.isHidden = false
//                    self.searchImageButton.setImage(UIImage(systemName: "multiply.circle.fill")!, for: .normal)
                } else {
                    self.clearTextFieldSetting()
                }
            }).disposed(by: disposeBag)

        
//        searchImageButton.rx.tap
//            .subscribe(onNext: { _ in
//                guard let data = self.searchTextField.text else { return }
//                if data.count > 0 {
//                    self.clearTextFieldSetting()
//                }
//            }).disposed(by: disposeBag)
    }
}

extension DefaultTextFieldCell: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(MyCell.self, forCellReuseIdentifier: "MyCell")
        table.separatorStyle = .none
        table.layer.cornerRadius = 10
        table.clipsToBounds = true
    }
    
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
            let filterData = filteredData[indexPath.row]
            cell.setData(filterData)
        } else {
            let data = data[indexPath.row]
            cell.setData(data)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
        let item = indexPath.row
        delegate?.didTappedCell(filteredData[item])
    }
}

//MARK: - Cell Preview
import SwiftUI
struct ForDefaultTextFieldCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        DefaultTextFieldCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct DefaultTextFieldCell_Preview: PreviewProvider {
    static var previews: some View {
        ForDefaultTextFieldCell()
            .previewLayout(.fixed(width: 393, height: 300))
    }
}
