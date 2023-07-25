//
//  RecipeReviewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

struct Review: Hashable {
    let id = UUID()
    let nickName: String
    let rate: Double
    let date: String
    let title: String
    let contents: String
    let like: Int
    let dislike: Int
    let photos: [UIImage]
}

struct ReviewTest: Hashable {
    let id = UUID()
    let txt: String
}

class RecipeReviewController: BaseViewController {
    
    enum Section: Hashable {
        case header
        case review
    }
    
    enum Item: Hashable {
        case header
        case review(Review)
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
    private var mockData: [Review] = [Review(nickName: "도레미", rate: 3.6, date: "2023-05-12", title: "맛있게 잘 먹었죠", contents: "국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요", like: 6, dislike: 3, photos: []),Review(nickName: "도레미", rate: 3.6, date: "2023-05-12", title: "맛있게 잘 먹었죠", contents: "국물이 아주그냥 끝내줘요", like: 6, dislike: 3, photos: []),Review(nickName: "도레미", rate: 3.6, date: "2023-05-12", title: "맛있게 잘 먹었죠", contents: "국물이 아주그냥 끝내줘요", like: 6, dislike: 3, photos: [])]
    
    private let mockData2: [ReviewTest] = [ReviewTest(txt: "물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요"),ReviewTest(txt: "내줘요"),ReviewTest(txt: "그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요"),ReviewTest(txt: "물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요국물이 아주그냥 끝내줘요")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.left.right.bottom.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        registerCell()
        configureDataSource()
        mockDataConfigure()
    }
}

//MARK: - Method(Normal)
extension RecipeReviewController {
    func mockDataConfigure() {
        mockData.append(Review(nickName: "도레미", rate: 3.6, date: "2023-05-12", title: "맛있게 잘 먹었죠", contents: "국물이 아주그냥 끝내줘요", like: 6, dislike: 3, photos: []))
    }
    
    func registerCell() {
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)
        collectionView.register(RecipeDetailReviewHeader.self, forCellWithReuseIdentifier: RecipeDetailReviewHeader.reuseIdentifier)
        collectionView.register(ReviewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewHeader.identifier)
        ///
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.reuseIdentifier)
    }
}

//MARK: - Method(Comp + Diff)
extension RecipeReviewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
//            let section = dataSource.snapshot().sectionIdentifiers[index]
//            switch section {
//            case .review:
//                var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//                configuration.headerMode = .supplementary
//                
//                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//                section.interGroupSpacing = 10
//                return section
//            default:
                return self.sectionFor(index: index, environment: env)
//            }
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .header:
            return createHeaderSection()
        case .review:
            return createCookStepSection()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45)), subitems: [headerItem])
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    func createCookStepSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(10)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(10)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .none
        
        
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
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeDetailReviewHeader.reuseIdentifier, for: indexPath) as! RecipeDetailReviewHeader
            return cell
        case .review(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as! ReviewCell
            cell.configure(data)
//            cell.configure(data)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .header:
            return UICollectionReusableView()
        case .review:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReviewHeader.identifier, for: indexPath) as! ReviewHeader
                return headerView
            
            
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .review])
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(mockData.map { Item.review($0) }, toSection: .review)

        
        return snapshot
    }
}

//MARK: - VC Preview
import SwiftUI
struct RecipeReviewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: RecipeReviewController()).toPreview()
    }
}
