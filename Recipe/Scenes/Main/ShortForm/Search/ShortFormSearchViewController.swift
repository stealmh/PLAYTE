//
//  ShortFormSearchViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation
import CoreData


class ShortFormSearchViewController: BaseViewController, UISearchBarDelegate {

    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
    var searchResultBackground = ShortFormSearchView()
    var defaultBackground = SearchDefaultView()
    var viewModel = SearchShortformViewModel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .white)
        view.addSubview(searchResultBackground)
        view.addSubview(defaultBackground)
        searchResultBackground.delegate = self
//        defaultBackground.backgroundColor = .red
//        searchResultBackground.backgroundColor = .blue
        searchResultBackground.snp.makeConstraints {
            $0.edges.equalTo(defaultBackground)
        }
        
        defaultBackground.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
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
        
        Task {
            await viewModel.setData()
        }
        
        viewModel.popularKeyword.subscribe(onNext: { data in
            self.defaultBackground.rankMockDataRelay.accept(data)
        }).disposed(by: disposeBag)
        
        viewModel.shortform.subscribe(onNext: { data in
            print(data)
            self.searchResultBackground.shortformInfo.accept(data)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension ShortFormSearchViewController {
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
                await viewModel.searchShortform(encodedString)
            }
            saveToCoreData(tag: text)
            defaultBackground.fetch()
        }
        searchBar.resignFirstResponder() // 키보드 숨김
    }
    
    func saveToCoreData(tag: String) {
        // 새로운 TagEntity 객체 생성
        let newTag = NSEntityDescription.insertNewObject(forEntityName: "TagEntity", into: context) as! TagEntity
        
        // 텍스트 값을 설정
        newTag.tag = tag
        
        // context에 저장
        do {
            try context.save()
            print("저장되었음")
        } catch {
            print("Error saving tag: \(error)")
        }
    }
}

extension ShortFormSearchViewController: ShortformReusltDelegate {
    func didTappedShortform(_ item: ShortFormInfo) {
        let vc = ShortFormFullScreenViewController(item: item, player: AVPlayer(), playerLayer: AVPlayerLayer())
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - VC Preview
import SwiftUI
struct ShortFormViewController12_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: ShortFormViewController())
            .toPreview()
    }
}
