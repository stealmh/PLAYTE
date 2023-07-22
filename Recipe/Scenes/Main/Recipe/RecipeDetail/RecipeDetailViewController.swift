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
    }
    
    enum Item: Hashable {
        case info
        case ingredient
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
//        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    func registerCell() {
        collectionView.register(RecipeDetailInfoCell.self, forCellWithReuseIdentifier: RecipeDetailInfoCell.reuseIdentifier)
        collectionView.register(RecipeDetailIngredientHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeDetailIngredientHeader.identifier)
        collectionView.register(RecipeDetailIngredientCell.self, forCellWithReuseIdentifier: RecipeDetailIngredientCell.reuseIdentifier)
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
            return createRecipeDescription()
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
    
    func createRecipeDescription() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        // Return
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
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeDetailInfoCell.reuseIdentifier, for: indexPath) as! RecipeDetailInfoCell
            return cell
        case .ingredient:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeDetailIngredientCell.reuseIdentifier, for: indexPath) as! RecipeDetailIngredientCell
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeDetailIngredientHeader.identifier, for: indexPath) as! RecipeDetailIngredientHeader
        return headerView
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.info, .ingredient])
        snapshot.appendItems([.info], toSection: .info)
        snapshot.appendItems([.ingredient], toSection: .ingredient)
        return snapshot
    }

}

//MARK: - VC Preview
import SwiftUI
struct RecipeDetailViewController_preview: PreviewProvider {
    static var previews: some View {
        RecipeDetailViewController().toPreview().ignoresSafeArea()
    }
}
