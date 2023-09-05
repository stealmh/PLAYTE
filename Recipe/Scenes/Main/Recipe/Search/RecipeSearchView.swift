//
//  RecipeSearchView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecipeSearchView: UIView {
    enum Section: Hashable {
        case recipe
    }
    
    enum Item: Hashable {
        case recipe(RecipeInfo)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    ///UI Properties
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.textPadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "F8F8F8")
        v.placeholder = "레시피 및 재료를 검색해보세요."
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    
    let searchImageButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(imageName: "search_svg", size: 24)
        v.setImage(img, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .mainColor
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    ///Properties
    private let disposeBag = DisposeBag()
    var delegate: RecipeViewDelegate?
    private var dataSource: Datasource!
//    recipeDetail

    
    private var mockRecipeData1: [RecipeInfo] = []
    var recipeInfo = PublishRelay<Recipe>()
    var recipeRecentInfo: [RecipeInfo]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(collectionView)
        configureLayout()
        registerCell()
        configureDataSource()
        collectionView.delegate = self
        
        recipeInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {data in
            print("== recipeInfo 호출 ==")
            self.mockRecipeData1 = []
            self.recipeRecentInfo = data.data.content
            var recipeInfo: [RecipeInfo] = []

                for i in data.data.content {
                    if UserReportHelper.shared.isUserIdInUserReports(userId: Int64(i.writtenid)) {
                        print("차단자 있음")
                    } else {
                        recipeInfo.append(i)
                    }
                }
            
            
            let unique = Array(NSOrderedSet(array: recipeInfo)) as! [RecipeInfo]
            self.mockRecipeData1 = unique
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeSearchView {
    func configureLayout() {
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        collectionView.register(RecipeCategoryCell.self, forCellWithReuseIdentifier: RecipeCategoryCell.reuseIdentifier)
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseIdentifier)
        collectionView.register(RecipeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeHeaderCell.reuseIdentifier)
    }
}

//MARK: Comp + Diff
extension RecipeSearchView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .recipe:
            return createRecipeSection()
        }
    }
    func createRecipeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
//        item.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .none
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
        case .recipe(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as! RecipeCell
            cell.configure(data)
            cell.favoriteButton.rx.tap
                .subscribe(onNext: { _ in
                    Task {
                        if data.is_saved {
                            let a: DeleteRecipeReuslt = try await NetworkManager.shared.get(.recipeUnSave("\(data.recipe_id)"), parameters: ["recipe-id": data.recipe_id])
                            if a.code == "SUCCESS" {
                                DispatchQueue.main.async {
                                    cell.favoriteButton.setImage(UIImage(named: "bookmark_svg")!, for: .normal)
                                }
                            }
                        } else {
                            let a: DeleteRecipeReuslt = try await NetworkManager.shared.get(.recipeSave("\(data.recipe_id)"), parameters: ["recipe-id": data.recipe_id])
                            
                            if a.code == "SUCCESS" {
                                DispatchQueue.main.async {
                                    cell.favoriteButton.setImage(UIImage(named: "bookmarkfill_svg")!, for: .normal)
                                }
                            }
                        }
                    }
                }).disposed(by: disposeBag)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeHeaderCell.reuseIdentifier, for: indexPath) as! RecipeHeaderCell
        
        headerView.recentButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if let recent = self.recipeRecentInfo {
                    var recentArray: [RecipeInfo] = []
                    for i in recent {
                        if UserReportHelper.shared.isUserIdInUserReports(userId: Int64(i.writtenid)) {
                            print("차단자 있음")
                        } else {
                            recentArray.append(i)
                        }
                    }

                    self.mockRecipeData1 = recentArray
                    self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
                }
                
            }).disposed(by: disposeBag)
        
        headerView.popularButton.rx.tap
            .subscribe(onNext: { _ in
                let data = self.mockRecipeData1.sorted { $0.comment_count > $1.comment_count }
                self.mockRecipeData1 = data
                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        headerView.minimumButton.rx.tap
            .subscribe(onNext: { _ in
                let data = self.mockRecipeData1.sorted { $0.cook_time < $1.cook_time }
                self.mockRecipeData1 = data
                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        return headerView
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.recipe])
        snapshot.appendItems(mockRecipeData1.map({ Item.recipe($0) }), toSection: .recipe)

        return snapshot
    }
}

extension RecipeSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .recipe(let data):
            print("tapped")
            delegate?.didTappedRecipeCell(item: data)
        }
    }
}


#if DEBUG
import SwiftUI
struct ForRecipeSearchView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeSearchView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeSearchView_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeSearchView()
    }
}
#endif
