//
//  SearchDefaultView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

struct SearchTag: Hashable {
    let id = UUID()
    let tag: String
}

class SearchDefaultView: UIView {
    enum Section: Hashable {
        case recent
        case popular
    }
    
    enum Item: Hashable {
        case recent(SearchTag)
        case popular(PopularRank)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isScrollEnabled = false
        return v
    }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    private var dataSource: Datasource!
    private var tagMockData: [SearchTag] = [SearchTag(tag: "dkssu")]
    private var rankMockData: [PopularRank] = []
    
    var rankMockDataRelay = PublishRelay<Search>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        configureLayout()
        registerCell()
        configureDataSource()
        if let tagEntities = fetchTagsFromCoreData() {
            self.tagMockData = tagEntities.map { SearchTag(from: $0) }
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }
        
        rankMockDataRelay.subscribe(onNext: { value in
            let convert = value.data
            for (idx, data) in convert.enumerated() {
                let popularRank = PopularRank(rank: idx + 1, keyword: data)
                self.rankMockData.append(popularRank)
            }
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: false)
            
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchDefaultView {
    
    func fetch() {
        if let tagEntities = fetchTagsFromCoreData() {
            self.tagMockData = tagEntities.map { SearchTag(from: $0) }
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }
    }
    
    func fetchTagsFromCoreData() -> [TagEntity]? {
        // 1. TagEntity에 대한 fetch request 생성
        let fetchRequest: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        
        // 2. 필요하다면 정렬 조건 추가
        let sortDescriptor = NSSortDescriptor(key: "tag", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 3. fetch request 실행
        do {
            let tags = try context.fetch(fetchRequest)
            print("tags:", tags)
            return tags
        } catch {
            print("Error fetching tags: \(error)")
            return nil
        }
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func registerCell() {
        collectionView.register(RecentSearchTagCell.self, forCellWithReuseIdentifier: RecentSearchTagCell.reuseIdentifier)
        collectionView.register(RecentSearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecentSearchHeader.reuseIdentifier)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.reuseIdentifier)
        collectionView.register(PopularHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PopularHeader.reuseIdentifier)
    }
}



extension SearchDefaultView {
    /// UICollectionView(frame: .zero, collectionViewLayout: _ 에 들어가는 함수)
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    /// 섹션별로 들어갈 수 있게 구분해놓은 함수입니다.
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .recent:
            return createPhotosSection()
        case .popular:
            return pupularSection()
        }
    }
    
    /// 사진/동영상 헤더를 포함한 격자 사진 섹션입니다.
    func createPhotosSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .estimated(20)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.1)),
            subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
//        section.interGroupSpacing = 30
//        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.orthogonalScrollingBehavior = .continuous
        // Return
        return section
        //        }
        
    }
    
    func pupularSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(20)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(40)),
            subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
//        section.interGroupSpacing = 30
//        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
//        section.orthogonalScrollingBehavior = .continuous
        // Return
        return section
        //        }
        
    }
    
    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath,section: section)
        }

        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    ///어떠한 Cell을 사용할 것인지 Enum값에 따라 구분지어주는 함수입니다.
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell{
        switch item {
        case .recent(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchTagCell.reuseIdentifier, for: indexPath) as! RecentSearchTagCell
            cell.configure(data)
            return cell
        case .popular(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCell.reuseIdentifier, for: indexPath) as! PopularCell
            cell.configure(data)
            return cell
        }
    }
    
    
    /// Cell의 헤더에 필요함!
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        
        switch section {
        case .recent:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecentSearchHeader.reuseIdentifier, for: indexPath) as! RecentSearchHeader
            headerView.delegate = self
            return headerView
        case .popular:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PopularHeader.reuseIdentifier, for: indexPath) as! PopularHeader
            
            return headerView
        }
    }
    
    /// For Snapshot
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.recent, .popular])
        snapshot.appendItems(tagMockData.map({ Item.recent($0) }), toSection: .recent)
        snapshot.appendItems(rankMockData.map({ Item.popular($0) }), toSection: .popular)
        return snapshot
    }
}

extension SearchDefaultView: RecentSearchDelegate {
    func didTappedDeleteKeyword() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TagEntity")

        do {
            // 모든 TagEntity 객체 검색
            let fetchedResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            for object in fetchedResults! {
                context.delete(object) // 객체 삭제
            }
            
            // 변경사항 저장
            try context.save()
            if let tagEntities = fetchTagsFromCoreData() {
                self.tagMockData = tagEntities.map { SearchTag(from: $0) }
                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
            }
            
        } catch {
            print("Error fetching or deleting objects: \(error)")
        }
    }
}

extension SearchTag {
    init(from entity: TagEntity) {
        self.tag = entity.tag ?? ""
    }
}

#if DEBUG
import SwiftUI
struct ForSearchDefaultView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        SearchDefaultView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct SearchDefaultView_Preview: PreviewProvider {
    static var previews: some View {
        ForSearchDefaultView()
        //            .previewLayout(.fixed(width: 350, height: 261))
//            .ignoresSafeArea()
    }
}
#endif
