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

class RecipeDetailViewController: BaseViewController {
    
    private let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "recipeDetail")
        v.layer.cornerRadius = 20
//        v.backgroundColor = .white
//        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.clipsToBounds = true
//
//        v.layer.masksToBounds = false
//        v.layer.shadowRadius = 2
//        v.layer.shadowOpacity = 0.1
//        v.layer.shadowOffset = CGSize(width: 0 , height:3)
        return v
    }()
    
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
        case recipe(RecipeDetailStep)
        case ingredientchucheon(IngredientRecipe)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
//        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private var mockShopList: [ShopingList] = [ShopingList(title: "대홍단 감자", price: 20000, image: UIImage(named: "popcat")!, isrocket: true),
                                               ShopingList(title: "전남 국내산 대추 방울", price: 13000, image: UIImage(named: "popcat")!, isrocket: false)]
    
    private var mockRecipe: [RecipeDetailStep] = [RecipeDetailStep(image: UIImage(named: "popcat")!, title: "양파를 채 썰어서 준비해주세요", contents: "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요", point: true),RecipeDetailStep(image: UIImage(named: "popcat")!, title: "양파를 채 썰어서 준비해주세요", contents: "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요", point: true),RecipeDetailStep(image: UIImage(named: "popcat")!, title: "양파를 채 썰어서 준비해주세요", contents: "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요", point: true),RecipeDetailStep(image: UIImage(named: "popcat")!, title: "양파를 채 썰어서 준비해주세요", contents: "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요", point: true),RecipeDetailStep(image: UIImage(named: "popcat")!, title: "양파를 채 썰어서 준비해주세요", contents: "당근이 노릇노릇하게 익으면 다 익은 당근을 그릇에 옮겨 20분정도 냉장고에서 식혀주세요", point: false)]
    
    private var chucheonRecipeMockData = [IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥", cookTime: "조리 시간 10분"),IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥", cookTime: "조리 시간 10분"),IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥", cookTime: "조리 시간 10분")]
    
    var mockData: [DetailIngredient] = [DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T"),
                                        DetailIngredient(ingredientTitle: "밥", ingredientCount: "3공기", seasoningTitle: "", seasoningCount: ""),
                                        DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T"),
                                        DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T")]
    private var dataSource: Datasource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addView()
        self.configureLayout()
        configureDataSource()
        registerCell()
        defaultNavigationBackButton(backButtonColor: .white)
    }
}

//MARK: - Method(Normal)
extension RecipeDetailViewController {
    func addView() {
        view.addSubViews(backgroundImage)
        view.addSubview(collectionView)
    }
    func configureLayout() {
        collectionView.backgroundColor = .clear
        backgroundImage.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(274)
        }
        
        collectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.left.right.bottom.equalToSuperview()
            
            $0.edges.equalToSuperview()
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
        backgroundImage.image = item.image
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
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        item.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(241)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 30, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
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
                heightDimension: .estimated(123)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.6)),
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
        snapshot.appendItems(mockRecipe.map({ Item.recipe($0) }), toSection: .recipe)
        snapshot.appendItems(chucheonRecipeMockData.map { Item.ingredientchucheon($0) }, toSection: .ingredientchucheon)
        return snapshot
    }
    
}

//MARK: - VC Preview
import SwiftUI
struct RecipeDetailViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: RecipeDetailViewController()).toPreview().ignoresSafeArea()
    }
}
