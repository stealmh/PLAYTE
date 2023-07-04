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
    var mockdata: [Refrigerator] = [
        Refrigerator(view: ColdRefrigeratorView()),
        Refrigerator(view: NormalRefrigeratorView()),]

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
//        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func registerCell() {
        collectionView.register(HomeHeader.self, forCellWithReuseIdentifier: HomeHeader.reuseIdentifier)
        collectionView.register(PagingSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingSectionFooterView.reuseIdentifier)
    }
}

/// Method - Compositional + Diffable
extension HomeViewController {
    
    typealias HomeHeader = RefrigeratorCell
    typealias HomeDatasource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>
    
    enum HomeSection: Hashable {
        case header
    }

    enum HomeItem: Hashable {
        case header(Refrigerator)
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

        }
    }
    
    /// Cell의 헤더에 필요함!
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: HomeSection) -> UICollectionReusableView {
        print(indexPath.row)
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
        }
    }
    
    private func createSnapshot() -> HomeSnapshot{
        var snapshot = HomeSnapshot()
        snapshot.appendSections([.header])
        
        snapshot.appendItems(mockdata.map { HomeItem.header($0) }, toSection: .header)
    
        return snapshot
    }
}
