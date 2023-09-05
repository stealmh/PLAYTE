//
//  RecipeDetailViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class RecipeDetailViewController: BaseViewController, RecipeDetailErrorDelegate {
    
    func noRecipe() {
        DispatchQueue.main.async {
            if let info = self.recipeInfo {
                RecipeCoreDataHelper.shared.deleteRecipe(byID: info.recipe_id)
            }
            self.showAlert(title: "확인", message: "삭제된 레시피입니다.")
        }
    }
    
    
    enum Section: Hashable {
        case info
        case ingredient
        case shopingList
        case recipe
        case ingredientchucheon
    }
    
    enum Item: Hashable {
        case info
        case ingredient(DetailIngredient)
        case shopingList(ShopingList)
        case recipe(RecipeDetailStages)
        case ingredientchucheon(Recommendation)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        //        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("리뷰 작성", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 5
        v.backgroundColor = .mainColor
        return v
    }()
    
    
    private var mockShopList: [ShopingList] = []
    private var mockStage: [RecipeDetailStages] = []
    var mockData: [DetailIngredient] = []
    var mock: [RecipeDetailIngredient] = []
    var recommendationRecipe: [Recommendation] = []
    
    private var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    private var checkDataAccept = PublishRelay<Bool>()
    var recipeComment: RecipeComment?
    var recipeInfo: RecipeInfo? {
        didSet {
            if let info = recipeInfo {
                print("info를 보냅니다")
                print("info:", info)
                viewModel.ingredient.accept(info)
            }
        }
    }
    var viewModel = RecipeDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addView()
        self.configureLayout()
        configureDataSource()
        registerCell()
        defaultNavigationBackButton(backButtonColor: .white)
        collectionView.delegate = self
        viewModel.delegate = self
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "more_svg"), style: .plain, target: self, action: #selector(moreButtonTapped))
        moreButton.tintColor = .white
        
        let rightBarButtonItems = [moreButton]
        
        // 바 버튼 아이템들을 화면의 navigationItem에 설정합니다.
        navigationItem.rightBarButtonItems = rightBarButtonItems
        
        registerButton.rx.tap
            .take(1)
            .subscribe(onNext: { _ in
                ///Todo: 분리
                if let thumbnail = self.recipeInfo {
                    let vc = CreateReviewController(recipeID: thumbnail.recipe_id)
                    DispatchQueue.main.async {
                        vc.createReviewView.recipeImageView.loadImage(from: thumbnail.recipe_thumbnail_img)
                    }
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }).disposed(by: disposeBag)
        
        viewModel.recipeDetail
            .subscribe(onNext: { data in
                print("===")
                print(data)
                print("===")
                self.viewModel.recipeID = data.data.recipe_id
                self.viewModel.writtenID = data.data.writtenid
                print("RecipeDetailVC 의 recipeID는 :: \(self.viewModel.recipeID)")
                Task {
                    let a: RecipeComment = try await NetworkManager.shared.get(.recipeComment("\(self.viewModel.recipeID)"))
                    self.recipeComment = a
                }
                self.mockData = self.viewModel.combineIngredients(data.data.ingredients)
                for i in data.data.ingredients {
                    let data: ShopingList = ShopingList(title: i.coupang_product_name, price: i.coupang_product_price, image: i.coupang_product_image, isrocket: i.is_rocket_delivery, link: i.coupang_product_url)
                    self.mockShopList.append(data)
                }
                for i in data.data.stages {
                    self.mockStage.append(i)
                }
                
                for i in data.data.recommendation_recipes {
                    self.recommendationRecipe.append(i)
                }
                
                self.checkDataAccept.accept(true)
                print("==  mockStage ==")
                print(self.mockStage)
                print("==  mockStage ==")
                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
            }).disposed(by: disposeBag)
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        viewModel.recipeDetail
//            .subscribe(onNext: { data in
//                print("===")
//                print(data)
//                print("===")
//                self.viewModel.recipeID = data.data.recipe_id
//                print("RecipeDetailVC 의 recipeID는 :: \(self.viewModel.recipeID)")
//                Task {
//                    let a: RecipeComment = try await NetworkManager.shared.get(.recipeComment("\(self.viewModel.recipeID)"))
//                    self.recipeComment = a
//                }
//                self.mockData = self.viewModel.combineIngredients(data.data.ingredients)
//                for i in data.data.ingredients {
//                    let data: ShopingList = ShopingList(title: i.coupang_product_name, price: i.coupang_product_price, image: i.coupang_product_image, isrocket: i.is_rocket_delivery, link: i.coupang_product_url)
//                    self.mockShopList.append(data)
//                }
//                for i in data.data.stages {
//                    self.mockStage.append(i)
//                }
//                
//                for i in data.data.recommendation_recipes {
//                    self.recommendationRecipe.append(i)
//                }
//                
//                self.checkDataAccept.accept(true)
//                print("==  mockStage ==")
//                print(self.mockStage)
//                print("==  mockStage ==")
//                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
//            }).disposed(by: disposeBag)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @objc func moreButtonTapped(sender: UIBarButtonItem) {
        
        let customViewController = ShortFormSheetViewController()
        customViewController.modalPresentationStyle = .custom
        customViewController.transitioningDelegate = self
        customViewController.delegate = self

        present(customViewController, animated: true, completion: nil)
        
    }
    
}

//MARK: - Method(Normal)
extension RecipeDetailViewController {
    func addView() {
        view.addSubViews(collectionView)
        view.addSubview(registerButton)
    }
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    func registerCell() {
        collectionView.register(RecipeDetailInfoCell.self, forCellWithReuseIdentifier: RecipeDetailInfoCell.reuseIdentifier)
        collectionView.register(RecipeDetailIngredientHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeDetailIngredientHeader.identifier)
        collectionView.register(ShopingListCell.self, forCellWithReuseIdentifier: ShopingListCell.reuseIdentifier)
        collectionView.register(RecipeDetailStepCell.self, forCellWithReuseIdentifier: RecipeDetailStepCell.reuseIdentifier)
        collectionView.register(RecipeDetailDefaultHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeDetailDefaultHeaderView.identifier)
        collectionView.register(LineFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LineFooter.identifier)
        collectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DefaultHeader.identifier)
        collectionView.register(CreateRecipeFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CreateRecipeFooter.identifier)
        collectionView.register(IngredientRecipeCell.self, forCellWithReuseIdentifier: IngredientRecipeCell.reuseIdentifier)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.reuseIdentifier)
        
        
    }
    
    func configureData(_ item: Recipe) {
        //        backgroundImage.image = item.image
    }
}

//MARK: - Method(Comp + Diff)
extension RecipeDetailViewController {
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .info:
            return createHeaderSection()
        case .ingredient:
            return createIngredientList()
        case .shopingList:
            return createShopingListSection()
        case .recipe:
            return createCookStepSection()
        case .ingredientchucheon:
            return createIngredientChucheon()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(241)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(360)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: -100, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
    func createIngredientList() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(30)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.7)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .none
        
        
        // Return
        return section
    }
    
    func createShopingListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(115)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
        section.orthogonalScrollingBehavior = .groupPaging
        // Return
        return section
    }
    
    func createCookStepSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(170)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(300)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(40.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .none
        
        
        // Return
        return section
    }
    
    func createIngredientChucheon() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)),
            subitem: item,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        // Return
        return section
    }
    
    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath, section: section)
        }
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell{
        switch item {
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeDetailInfoCell.reuseIdentifier, for: indexPath) as! RecipeDetailInfoCell
            cell.delegate = self
            cell.reviewButton.rx.tap
                .subscribe(onNext: { _ in
                    print("tapped")
                }).disposed(by: disposeBag)
            cell.favoriteButton.rx.tap
                .subscribe(onNext: { _ in
                    print("tapped")
                }).disposed(by: disposeBag)
            viewModel.recipeDetail.subscribe(onNext: { data in
                cell.configure(data.data)
                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
            }).disposed(by: disposeBag)
            return cell
        case .ingredient(let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.reuseIdentifier, for: indexPath) as! IngredientCell
            cell.configure(item)
            return cell
        case .shopingList(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopingListCell.reuseIdentifier, for: indexPath) as! ShopingListCell
            cell.configure(data)
            return cell
        case .recipe(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeDetailStepCell.reuseIdentifier, for: indexPath) as! RecipeDetailStepCell
            cell.configure(data, idx: indexPath.row + 1)
            return cell
        case .ingredientchucheon(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientRecipeCell.reuseIdentifier, for: indexPath) as! IngredientRecipeCell
            cell.configure(data)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .ingredient:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeDetailIngredientHeader.identifier, for: indexPath) as! RecipeDetailIngredientHeader
            return headerView
        case .recipe:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeDetailDefaultHeaderView.identifier, for: indexPath) as! RecipeDetailDefaultHeaderView
                
                checkDataAccept.subscribe(onNext: { isTrue in
                    headerView.configure(self.mockStage.count)
                }).disposed(by: disposeBag)
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineFooter.identifier, for: indexPath) as! LineFooter
                return footerView
            }
        case .ingredientchucheon:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
                headerView.configureTitle(text: "이런 레시피는 어때요?")
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CreateRecipeFooter.identifier, for: indexPath) as! CreateRecipeFooter
                footerView.configure("리뷰 작성하기")
                footerView.registerButton.rx.tap
                    .take(1)
                    .subscribe(onNext: { _ in
                        ///Todo: 분리
                        if let thumbnail = self.recipeInfo {
                            let vc = CreateReviewController(recipeID: thumbnail.recipe_id)
                            DispatchQueue.main.async {
                                vc.createReviewView.recipeImageView.loadImage(from: thumbnail.recipe_thumbnail_img)
                            }
                            vc.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                        }

                    }).disposed(by: disposeBag)
                return footerView
            }
        default: return UICollectionReusableView()
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.info, .ingredient, .shopingList, .recipe, .ingredientchucheon])
        snapshot.appendItems([.info], toSection: .info)
        snapshot.appendItems(mockData.map({ Item.ingredient($0) }), toSection: .ingredient)
        snapshot.appendItems(mockShopList.map({ Item.shopingList($0) }), toSection: .shopingList)
        snapshot.appendItems(mockStage.map({ Item.recipe($0) }), toSection: .recipe)
        snapshot.appendItems(recommendationRecipe.map { Item.ingredientchucheon($0) }, toSection: .ingredientchucheon)
        return snapshot
    }
}

extension RecipeDetailViewController: RecipeDetailInfoDelegate {
    func favoriteButtonTapped(_ recipeId: Int) {
//        Task {
//            let data: DefaultReturnBool = try await NetworkManager.shared.get(.recipeSave("\(recipeId)"))
//            if
//        }
    }
    
    func showReview() {
        print(#function)
        let recipeID = viewModel.recipeID
        if let comment = recipeComment, let info = recipeInfo {
            Task {
                let data3: ReviewList = try await NetworkManager.shared.get(.recipeReview("\(recipeID)", .popular))
                let a = data3.data.content.count
                let vc = SegmentViewController(recipeID: recipeID, shortFormId: 0, comment: comment, reviewCount: a)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension RecipeDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let item = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.item]
        
        switch item {
        case .info:
            break
        case .ingredient(let ingredient):
            break
        case .shopingList(let shopingList):
            openShopingListURL(shopingList.link)
            break
        case .recipe(let recipeDetailStage):
            break
        case .ingredientchucheon(let recommendation):
            break
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // 쇼핑 리스트 아이템의 링크를 열기 위한 메서드
    private func openShopingListURL(_ link: String) {
        guard let url = URL(string: link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL: \(url)")
        }
    }
}

extension RecipeDetailViewController: SheetActionDelegate, UIViewControllerTransitioningDelegate{
    func didTappedUserReport() {
//        print("writtenID:", viewModel.writtenID)
        if let info = recipeInfo, !UserReportHelper.shared.isUserIdInUserReports(userId: Int64(info.writtenid)) {
            print("writtenid는 ->", info.writtenid)
            if UserReportHelper.shared.createUserReport(userId: Int64(viewModel.writtenID)) {
                Task {
                    let data: DefaultReturnBool = try await NetworkManager.shared.get(.recipeUnSave("\(info.recipe_id)"))
                }
                RecipeCoreDataHelper.shared.deleteRecipe(byID: info.recipe_id)
                self.dismiss(animated:true) {
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.showToastSuccess(message: "사용자가 차단되었습니다.")
                }
            }
        }
    }
    
    func didTappedNoInterest() {
        if let info = recipeInfo {
            Task {
                if let data = await viewModel.notInterest(info.recipe_id), data.data {
                    self.dismiss(animated:true) {
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.showToastSuccess(message: "관심없는 동영상으로 설정하였습니다.")
                    }
                }
            }
        }
    }
    
    func didTappedReport() {
        if let info = recipeInfo {
            Task {
                if let data = await viewModel.report(info.recipe_id), data.data {
                    RecipeCoreDataHelper.shared.deleteRecipe(byID: info.recipe_id)
                    self.dismiss(animated:true) {
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.showToastSuccess(message: "신고가 접수되었습니다.")
                    }
                }
            }
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        PresentationController(presentedViewController: presented, presenting: presenting)
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 205)
    }
}

extension RecipeDetailViewController: CreateReviewControllerDelegate {
    func endFlow() {
        print("RecipeDetailViewController")
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - VC Preview
import SwiftUI
struct RecipeDetailViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: RecipeDetailViewController()).toPreview().ignoresSafeArea()
    }
}
