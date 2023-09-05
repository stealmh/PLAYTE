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
    var viewModel = SearchRecipeViewModel()
    var defaultBackground = SearchDefaultView()
    var searchResultBackground = RecipeSearchView()
    var initialValue: (Recipe, Theme)? {
        didSet {
            if let value = initialValue {
                DispatchQueue.main.async {
                    switch value.1 {
                    case .budgetHappiness:
                        self.searchBar.text = "알뜰살뜰 만원의 행복"
                        self.handleSearchBarTextChange(text: "알뜰살뜰 만원의 행복")
                    case .forDieting:
                        self.searchBar.text = "다이어터를 위한 레시피"
                        self.handleSearchBarTextChange(text: "다이어터를 위한 레시피")
                    case .houseWarming:
                        self.searchBar.text = "집들이용 레시피"
                        self.handleSearchBarTextChange(text: "집들이용 레시피")
                    case .livingAlone:
                        self.searchBar.text = "자취생 필수!"
                        self.handleSearchBarTextChange(text: "자취생 필수!")
                        
                    }
                    self.viewModel.themeRecipe.accept(value)
                }
            }
        }
    }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultBackground.delegate = self
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
        
        //        viewModel.themeRecipe
        //            .subscribe(onNext: { (data, theme) in
        //                print("hello~~")
        //                self.searchResultBackground.recipeInfo.accept(data)
        //                switch theme {
        //                case .budgetHappiness:
        //                    self.searchBar.text = "알뜰살뜰 만원의 행복"
        //                case .forDieting:
        //                    self.searchBar.text = "다이어터를 위한 레시피"
        //                case .houseWarming:
        //                    self.searchBar.text = "집들이용 레시피"
        //                case .livingAlone:
        //                    self.searchBar.text = "자취생 필수!"
        //
        //                }
        //            }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(onNext: handleSearchBarTextChange)
            .disposed(by: disposeBag)
        Task {
            await viewModel.setData()
        }
        
        viewModel.popularKeyword.subscribe(onNext: { data in
            self.defaultBackground.rankMockDataRelay.accept(data)
        }).disposed(by: disposeBag)
        
        viewModel.searchRecipe.subscribe(onNext: { data in
            self.searchResultBackground.recipeInfo.accept(data)
        }).disposed(by: disposeBag)
        
        viewModel.themeRecipe.subscribe(onNext: { (data,value) in
            self.searchResultBackground.recipeInfo.accept(data)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.tabBarController?.tabBar.isHidden = false
    }
}

extension RecipeSearchViewController {
    func searchBarConfigure() {
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.barTintColor = UIColor.hexStringToUIColor(hex: "F8F8F8")
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "clearButton_svg"), for: .clear, state: .normal)
        
        // 네비게이션 바에 UISearchBar 추가
        navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, let encodedString = text.encoded {
            Task {
                await viewModel.searchRecipe(encodedString)
            }
        }
        searchBar.resignFirstResponder() // 키보드 숨김
    }
    
    func handleSearchBarTextChange(text: String) {
        if !text.isEmpty {
            self.defaultBackground.isHidden = true
            self.searchResultBackground.isHidden = false
        } else {
            self.defaultBackground.isHidden = false
            self.searchResultBackground.isHidden = true
        }
    }
}

extension RecipeSearchViewController: RecipeViewDelegate {
    func didTappedThemeButton(_ theme: Theme) {
        //해당 뷰에서 사용할 일 없음 옵셔널 protocol로 만들어야함
    }
    
    func didTappedRecipeCell(item: RecipeInfo) {
        let vc = RecipeDetailViewController()
        vc.recipeInfo = item
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTappedSortButton(_ tag: Int) {
        
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
