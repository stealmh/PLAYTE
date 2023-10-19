//
//  GoViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MypageViewController: BaseViewController {
    
    var didSendEventClosure: ((MypageViewController.Event) -> Void)?
    var disposeBag = DisposeBag()
    private var myPageView = MyPageView()
    var viewModel = MyPageViewModel()
    var favoriteRecipe: Recipe1?
    var writeRecipe: Recipe1?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myPageView)
        myPageView.delegate = self
        configureLayout()
        configureNavigationTabBar()
        myPageView.viewModel = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myPageView.viewModel = viewModel
    }
    
    func fetchAllRecipes(completion: @escaping ([NewRecipeInfoEntity]?) -> Void) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                LoadingIndicator.showLoading()
            }
            let result = RecipeCoreDataHelper.shared.fetchAllRecipes()
            DispatchQueue.main.async {
                completion(result)
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    func fetchAllShortforms(completion: @escaping ([ShortFormInfoEntity]?) -> Void) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                LoadingIndicator.showLoading()
            }
            let result = ShortFormCoreDataHelper.shared.fetchAllShortForms()
            DispatchQueue.main.async {
                completion(result)
                LoadingIndicator.hideLoading()
            }
        }
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        myPageView.viewModel = viewModel
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        Task {
            DispatchQueue.main.async {
                LoadingIndicator.showLoading()
            }
            if let data:[ShortFormInfoEntity] = ShortFormCoreDataHelper.shared.fetchAllShortForms() {
                print(data)
                self.myPageView.recentShortFormRelay.accept(data)
            }
            
            if let data1:[NewRecipeInfoEntity] = RecipeCoreDataHelper.shared.fetchAllRecipes() {
                print(data1)
                self.myPageView.recentRecipeForRelay.accept(data1)
            }
            
            DispatchQueue.main.async {
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    enum Event {
        case go
        case favoriteReceipeButtonTapped
        case writeRecipeButtonTapped
        case myReviewButtonTapped
        case recentShortFormCellTapped
        case recentRecipeCellTapped
        case settingButtonTapped
    }
    
    @objc func settingButtonTapped() {
        self.tabBarController?.tabBar.isHidden = true
        didSendEventClosure?(.settingButtonTapped)
    }
}

//MARK: - Method(Normal)
extension MypageViewController {
    
    private func configureLayout() {
        myPageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationTabBar() {
//        let img = UIImage(named: "setting_svg")!
        let settingButton = UIBarButtonItem(image: UIImage(named: "setting_svg"), style: .done, target: self, action: #selector(settingButtonTapped))
        settingButton.tintColor = .grayScale4!
        navigationItem.rightBarButtonItem = settingButton
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "mypage", size: CGSize(width: 96.36, height: 28.52))
        navigationController?.navigationBar.barTintColor = .white
    }
}

import AVFoundation
extension MypageViewController: MyPageViewDelegate {
    func sendMyInfo(_ item: MyInfo1) {
        print("")
    }
    
    func favoriteReceipeButtonTapped(item: Recipe1?) {
        self.favoriteRecipe = item
        self.tabBarController?.tabBar.isHidden = true
        didSendEventClosure?(.favoriteReceipeButtonTapped)
    }
    
    func writeRecipeButtonTapped(item: Recipe1?) {
        print(item)
        self.writeRecipe = item
        self.tabBarController?.tabBar.isHidden = true
        didSendEventClosure?(.writeRecipeButtonTapped)
    }
    
    func myReviewButtonTapped() {
        self.tabBarController?.tabBar.isHidden = true
        didSendEventClosure?(.myReviewButtonTapped)
    }
    
    func recentShortFormCellTapped(item: ShortFormInfo) {
        let vc = ShortFormFullScreenViewController(item: item, player: AVPlayer(), playerLayer: AVPlayerLayer())
        navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func recentRecipeCellTapped(item: RecipeInfo) {
        print(item)
        let vc = RecipeDetailViewController()
        vc.recipeInfo = item
        navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
}
