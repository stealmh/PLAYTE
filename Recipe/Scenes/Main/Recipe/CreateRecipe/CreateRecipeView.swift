//
//  CreateRecipeView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateRecipeView: UIView {
    
    enum Section: Hashable {
        case header
        case recipeNameSection
        case recipeSearchSection
        case cookTimeSettingSection
    }
    
    enum Item: Hashable {
        case header
        case recipeNameSection
        case recipeSearchSection
        case cookTimeSettingSection
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        registerCell()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

//MARK: - Method(Normal)
extension CreateRecipeView {
    
    func addView() {
        addSubViews(collectionView)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func registerCell() {
        collectionView.register(CreateRecipeHeaderCell.self , forCellWithReuseIdentifier: CreateRecipeHeaderCell.reuseIdentifier)
        collectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DefaultHeader.identifier)
        collectionView.register(TextFieldCell.self , forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        collectionView.register(CookTimeSettingCell.self , forCellWithReuseIdentifier: CookTimeSettingCell.reuseIdentifier)
    }
}
//MARK: Comp + Diff
extension CreateRecipeView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .header:
            return createHeaderSection()
        case .recipeNameSection, .recipeSearchSection, .cookTimeSettingSection:
            return createEqualSize()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2)), subitems: [headerItem])
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    func createEqualSize() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)),
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateRecipeHeaderCell.reuseIdentifier, for: indexPath) as! CreateRecipeHeaderCell
            return cell
        case .recipeNameSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(text: "레시피 이름을 입력해주세요", needSearchButton: false)
            return cell
        case .recipeSearchSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(text: "재료 이름을 검색해주세요", needSearchButton: true)
            return cell
        case .cookTimeSettingSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookTimeSettingCell.reuseIdentifier, for: indexPath) as! CookTimeSettingCell
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .header:
            return UICollectionReusableView()
        case .recipeNameSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "레시피 이름")
            return headerView
        case .recipeSearchSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "레시피 재료")
            return headerView
        case .cookTimeSettingSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "조리 시간 분")
            headerView.highlightTextColor()
            return headerView
            
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .recipeNameSection, .recipeSearchSection, .cookTimeSettingSection])
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems([.recipeNameSection], toSection: .recipeNameSection)
        snapshot.appendItems([.recipeSearchSection], toSection: .recipeSearchSection)
        snapshot.appendItems([.cookTimeSettingSection], toSection: .cookTimeSettingSection)

        return snapshot
    }
}

//MARK: - Method(Rx Bind)
extension CreateRecipeView {
    
}

extension CreateRecipeView {
    
}

import SwiftUI
struct ForNewCreateRecipeView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        CreateRecipeView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct NewCreateRecipeView_Preview: PreviewProvider {
    static var previews: some View {
        ForNewCreateRecipeView()
    }
}