//
//  RecipeDetailIngredientCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/22.
//

import UIKit
import SnapKit

struct DetailIngredient: Hashable {
    let id = UUID()
    let ingredientTitle: String
    let ingredientCount: String
    let seasoningTitle: String
    let seasoningCount: String
}

final class RecipeDetailIngredientCell: UICollectionViewCell {
    
    enum Section: Hashable {
        case ingredient
    }
    
    enum Item: Hashable {
        case ingredient(DetailIngredient)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        return v
    }()
    private var dataSource: Datasource!
    var mockData: [DetailIngredient] = [DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T"),
                                        DetailIngredient(ingredientTitle: "밥", ingredientCount: "3공기", seasoningTitle: "", seasoningCount: ""),
                                        DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T"),
                                        DetailIngredient(ingredientTitle: "토마토", ingredientCount: "2개", seasoningTitle: "굴소스", seasoningCount: "2T")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
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
extension RecipeDetailIngredientCell {
    func addView() {
        addSubview(collectionView)
    }
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func configure() {} //for data inject
    func registerCell() {
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.reuseIdentifier)
    }
}

//MARK: - Method(Rx bind)
extension RecipeDetailIngredientCell {
    func bind() {}
}

//MARK: - Method(Comp + Diff)
extension RecipeDetailIngredientCell {
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .ingredient:
            return createHeaderSection()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.2)), subitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell{
        switch item {
        case .ingredient(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.reuseIdentifier, for: indexPath) as! IngredientCell
            cell.configure(data)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeHeaderCell.reuseIdentifier, for: indexPath) as! RecipeHeaderCell
        return UICollectionReusableView()
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.ingredient])
        snapshot.appendItems(mockData.map({ Item.ingredient($0) }), toSection: .ingredient)
        return snapshot
    }

}


#if DEBUG
import SwiftUI
struct ForRecipeDetailIngredientCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeDetailIngredientCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeDetailIngredientCell_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeDetailIngredientCell()
            .previewLayout(.fixed(width: 380, height: 80))
    }
}
#endif
