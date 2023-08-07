//
//  ShortFormSearchView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShortFormSearchView: UIView {
    
    enum Section: Hashable {
        case result
    }
    
    enum Item: Hashable {
        case result(ShortFormSearch)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    /// UI Properties
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    /// Properties
    private var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    
    private var mockShopList: [ShortFormSearch] = [ShortFormSearch(nickName: "abcd123", video: "naver.com", contents: "토마토계란볶음밥", playTime: "02:12", thumnail: UIImage(named: "popcat")!),
                                                   ShortFormSearch(nickName: "하하호12", video: "naver.com", contents: "토마토계란볶음밥 심화", playTime: "01:23", thumnail: UIImage(named: "popcat")!),
                                                   ShortFormSearch(nickName: "happy66", video: "naver.com", contents: "토마토계란볶음밥", playTime: "02:12", thumnail: UIImage(named: "popcat")!),
                                                   ShortFormSearch(nickName: "abcd123", video: "naver.com", contents: "토마토계란볶음밥", playTime: "02:12", thumnail: UIImage(named: "popcat")!),
                                                   ShortFormSearch(nickName: "abcd123", video: "naver.com", contents: "토마토계란볶음밥", playTime: "02:12", thumnail: UIImage(named: "popcat")!),
                                                   ShortFormSearch(nickName: "abcd123", video: "naver.com", contents: "토마토계란볶음밥", playTime: "02:12", thumnail: UIImage(named: "popcat")!),]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        configureLayout()
        registerCell()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method(Normal)
extension ShortFormSearchView {
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func registerCell() {
        collectionView.register(ShortFormSearchCell.self, forCellWithReuseIdentifier: ShortFormSearchCell.reuseIdentifier)
        collectionView.register(ShortFormSearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShortFormSearchHeader.reuseIdentifier)
    }
}

//MARK: - Method(Comp + Diff)
extension ShortFormSearchView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .result:
            return createShopingListSection()
        }
    }
    
    func createShopingListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.35)),
            subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(30.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
//        section.orthogonalScrollingBehavior = .paging
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
        case .result(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortFormSearchCell.reuseIdentifier, for: indexPath) as! ShortFormSearchCell
            cell.configure(data)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .result:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShortFormSearchHeader.reuseIdentifier, for: indexPath) as! ShortFormSearchHeader
            return headerView
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.result])
        snapshot.appendItems(mockShopList.map({ Item.result($0) }), toSection: .result)
        return snapshot
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormSearchView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormSearchView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ShortFormSearchView_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormSearchView()
            .ignoresSafeArea()
    }
}
#endif
