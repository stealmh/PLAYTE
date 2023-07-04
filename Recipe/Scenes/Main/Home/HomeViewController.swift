//
//  HomeViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    private var dataSource: HomeDatasource!
    private var disposeBag = DisposeBag()
    private let pagingInfoSubject = PublishSubject<PagingInfo>()
    
    private let titleView = TitleView()
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //Mock Data
    var refrigeratorMock: [Refrigerator] = [
        Refrigerator(view: ColdRefrigeratorView()),
        Refrigerator(view: NormalRefrigeratorView()),]
    
    var priceTrendMock: [PriceTrend] = [
        PriceTrend(title: "계란", transition: "+8%", count: 3, price: 231),
        PriceTrend(title: "계란", transition: "+8%", count: 3, price: 231),
        PriceTrend(title: "계란", transition: "+8%", count: 3, price: 231),]
    
    var chucheonRecipeMockData: [IngredientRecipe] = [
    IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥", cookTime: "조리 시간 10분"),
    IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥에서 음식이길다면", cookTime: "조리 시간 10분"),
    IngredientRecipe(image: UIImage(named: "popcat")!, title: "토마토 계란볶음밥", cookTime: "조리 시간 10분"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        configureNavigationTabBar()
        configureLayout()
        registerCell()
        configureDataSource()
    }
    
}

/// Method - Normal
private extension HomeViewController {
    func configureNavigationTabBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "popcat", size: CGSize(width: 40, height: 40))
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleView
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        // 인덱스패스위치로 컬렉션 뷰를 스크롤
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func registerCell() {
        collectionView.register(HomeHeader.self, forCellWithReuseIdentifier: HomeHeader.reuseIdentifier)
        collectionView.register(PagingSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingSectionFooterView.reuseIdentifier)
        
        collectionView.register(HomeSecondSectionItem.self, forCellWithReuseIdentifier: HomeSecondSectionItem.reuseIdentifier)
        collectionView.register(HomeSecondSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSecondSectionHeader.identifier)
        
        collectionView.register(IngredientRecipeCell.self, forCellWithReuseIdentifier: IngredientRecipeCell.reuseIdentifier)
        collectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DefaultHeader.identifier)
    }
}

/// Method - Compositional + Diffable
extension HomeViewController {
    
    typealias HomeHeader = RefrigeratorCell
    typealias HomeSecondSectionHeader = PriceTrendHeader
    typealias HomeSecondSectionItem = PriceTrendCell
    typealias HomeThirdSectionHeader = DefaultHeader
    typealias HomeThirdSectionItem = IngredientRecipeCell
    typealias HomeDatasource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>
    
    enum HomeSection: Hashable {
        case header
        case priceTrend
        case ingredientRecipe
    }
    
    enum HomeItem: Hashable {
        case header(Refrigerator)
        case priceTrend(PriceTrend)
        case ingredientRecipe(IngredientRecipe)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .header:
            return createHeaderSection(index)
        case .priceTrend:
            return createPriceTrendSection()
        case .ingredientRecipe:
            return createIngredientRecipeSection()
        }
    }
    
    func createHeaderSection(_ idx: Int) -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), subitems: [headerItem])
        
        let section = NSCollectionLayoutSection(group: headerGroup)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        //
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))
        let pagingFooterElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems += [pagingFooterElement]
        
        // MARK: Page control setup
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
            guard let self = self else { return }
            
            let page = round(offset.x / self.view.bounds.width)
            
            self.pagingInfoSubject.onNext(PagingInfo(sectionIndex: idx, currentPage: Int(page)))
        }
        return section
    }
    
    func createPriceTrendSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.40),
                heightDimension: .absolute(115)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        // Return
        return section
    }
    
    func createIngredientRecipeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalHeight(0.3)),
            subitem: item,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(40.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        // Return
        return section
    }
    
    private func configureDataSource() {
        dataSource = HomeDatasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath,section: section)
        }
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: HomeItem) -> UICollectionViewCell{
        switch item {
        case .header(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeader.reuseIdentifier, for: indexPath) as! HomeHeader
            cell.configure(data: data)
            return cell
        case .priceTrend(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSecondSectionItem.reuseIdentifier, for: indexPath) as! HomeSecondSectionItem
            cell.configure(ingredients: data)
            return cell
        case .ingredientRecipe(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientRecipeCell.reuseIdentifier, for: indexPath) as! IngredientRecipeCell
            cell.configure(data)
            return cell
            
        }
    }
    
    /// Cell의 헤더에 필요함!
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: HomeSection) -> UICollectionReusableView {
        switch section {
        case .header:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeader.reuseIdentifier, for: indexPath) as! HomeHeader
                return headerView
            } else {
                let pagingFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingSectionFooterView.reuseIdentifier, for: indexPath) as! PagingSectionFooterView
                let itemCount = self.dataSource.snapshot().numberOfItems(inSection: .header)
                pagingFooter.configure(with: itemCount)
                
                pagingInfoSubject
                    .filter { $0.sectionIndex == indexPath.section }
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] pagingInfo in
                        pagingFooter.pageControl.currentPage = pagingInfo.currentPage
                        if pagingInfo.currentPage == 0 {
                            self?.titleView.iceButton.setTitleColor(.black, for: .normal)
                            self?.titleView.notIceButton.setTitleColor(.gray, for: .normal)
                        } else {
                            self?.titleView.iceButton.setTitleColor(.gray, for: .normal)
                            self?.titleView.notIceButton.setTitleColor(.black, for: .normal)
                        }
                    }).disposed(by: disposeBag)
                
                pagingFooter.pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)
                return pagingFooter
            }
        case .priceTrend:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSecondSectionHeader.identifier, for: indexPath) as! HomeSecondSectionHeader
            return headerView
            
        case .ingredientRecipe:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "My 재료 활용 레시피")
            return headerView
        }
    }
    
    private func createSnapshot() -> HomeSnapshot{
        var snapshot = HomeSnapshot()
        snapshot.appendSections([.header, .priceTrend, .ingredientRecipe])
        
        snapshot.appendItems(refrigeratorMock.map { HomeItem.header($0) }, toSection: .header)
        snapshot.appendItems(priceTrendMock.map { HomeItem.priceTrend($0) }, toSection: .priceTrend)
        snapshot.appendItems(chucheonRecipeMockData.map { HomeItem.ingredientRecipe($0) }, toSection: .ingredientRecipe)
        
        return snapshot
    }
}
