//
//  RecipeSearchViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeSearchViewController: BaseViewController, UISearchBarDelegate {

    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
    var defaultBackground = SearchDefaultView()
    var searchResultBackground = RecipeSearchView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
        view.addSubview(defaultBackground)
        view.addSubview(searchResultBackground)
//        defaultBackground.backgroundColor = .red
        defaultBackground.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        searchResultBackground.backgroundColor = .blue
        searchResultBackground.snp.makeConstraints {
            $0.edges.equalTo(defaultBackground)
        }
        
        searchBar.rx.text.orEmpty
            .subscribe(onNext: { txt in
                if !txt.isEmpty {
                    self.defaultBackground.isHidden = true
                    self.searchResultBackground.isHidden = false
                } else {
                    self.defaultBackground.isHidden = false
                    self.searchResultBackground.isHidden = true
                }
            }).disposed(by: disposeBag)
//        searchBar.rx.textDidBeginEditing
//            .skip(1)
//            .subscribe(onNext: { _ in
//                print("a")
//                self.defaultBackground.isHidden = true
//                self.searchResultBackground.isHidden = false
//            }).disposed(by: disposeBag)
//        searchBar.rx.textDidEndEditing
//            .skip(1)
//            .subscribe(onNext: { _ in
//                print("b")
//                self.defaultBackground.isHidden = false
//                self.searchResultBackground.isHidden = true
//            }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension RecipeSearchViewController {
    func searchBarConfigure() {
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.barTintColor = .lightGray // 바 배경 색상 설정
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "clearButton_svg"), for: .clear, state: .normal)

        // 네비게이션 바에 UISearchBar 추가
        navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 로직을 여기에 구현합니다.
        // searchBar.text를 사용하여 검색어를 가져올 수 있습니다.
        searchBar.resignFirstResponder() // 키보드 숨김
    }
}

extension RecipeSearchViewController: RecipeViewDelegate {
    func didTappedRecipeCell(item: Recipe) {
        print("")
    }
    
    
}

//MARK: - VC Preview
import SwiftUI
struct RecipeSearchViewController_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: RecipeSearchViewController())
            .toPreview()
    }
}
