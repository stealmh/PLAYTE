//
//  RecipeView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RecipeViewDelegate {
    func didTappedRecipeCell(item: Recipe)
}

struct MockCategoryData: Hashable {
    let id = UUID()
    let text: String
    let color: UIColor
}

final class RecipeView: UIView {
    enum Section: Hashable {
        case header
        case recipe
    }
    
    enum Item: Hashable {
        case header(MockCategoryData)
        case recipe(Recipe)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    ///UI Properties
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.textPadding = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 20)
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.placeholder = "레시피 및 재료를 검색해보세요."
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(systemImageName: "magnifyingglass", size: 25)
        v.setImage(img, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    ///Properties
//    private let disposeBag = DisposeBag()
    var delegate: RecipeViewDelegate?
    private var dataSource: Datasource!
    private let mockCategoryData: [MockCategoryData] = [
        MockCategoryData(text: "소중한 사람을 위해", color: .red),
        MockCategoryData(text: "건강한 식습관", color: .green),
        MockCategoryData(text: "알뜰살뜰 만원의 행복", color: .yellow),
        MockCategoryData(text: "내가 바로 미슐랭 스타", color: .blue)]
    private let mockRecipeData: [Recipe] = [
        Recipe(image: UIImage(named: "recipeDetail")!, title: "토마토 계란 볶음밥1", tag: "토마토", isFavorite: true, cookTime: "10분"),
        Recipe(image: UIImage(named: "popcat")!, title: "토마토 계란 볶음밥 길이를 체크합니다", tag: "토마토", isFavorite: false, cookTime: "10분"),
        Recipe(image: UIImage(named: "popcat")!, title: "토마토 계란 볶음밥2", tag: "토마토", isFavorite: true, cookTime: "10분"),
        Recipe(image: UIImage(named: "popcat")!, title: "토마토 계란 볶음밥3", tag: "토마토", isFavorite: true, cookTime: "10분"),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(searchTextField, searchImageButton, collectionView)
        configureLayout()
        registerCell()
        configureDataSource()
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Method(Normal)
extension RecipeView {
    func configureLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(13)
            $0.height.equalTo(51.57)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.left.equalTo(searchTextField).inset(15)
            $0.centerY.equalTo(searchTextField)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
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
extension RecipeView {
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
        case .recipe:
            return createRecipeSection()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.49), heightDimension: .absolute(150)), subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func createRecipeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7)), subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
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
        case .header(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCategoryCell.reuseIdentifier, for: indexPath) as! RecipeCategoryCell
            cell.configureData(text: data.text, color: data.color)
            return cell
            
        case .recipe(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as! RecipeCell
            cell.configure(data)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeHeaderCell.reuseIdentifier, for: indexPath) as! RecipeHeaderCell
        return headerView
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .recipe])
        snapshot.appendItems(mockCategoryData.map({ Item.header($0) }), toSection: .header)
        snapshot.appendItems(mockRecipeData.map({ Item.recipe($0) }), toSection: .recipe)

        return snapshot
    }
}

extension RecipeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .recipe(let data):
            delegate?.didTappedRecipeCell(item: data)
        default:
            return
        }
    }
}


#if DEBUG
import SwiftUI
struct ForRecipeView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        RecipeView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RecipeView_Preview: PreviewProvider {
    static var previews: some View {
        ForRecipeView()
    }
}
#endif
