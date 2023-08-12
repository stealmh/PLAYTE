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
    let img: UIImage
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
        v.textPadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        v.backgroundColor = .gray.withAlphaComponent(0.1)
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
//        v.isScrollEnabled = false
        return v
    }()
    
    ///Properties
//    private let disposeBag = DisposeBag()
    var delegate: RecipeViewDelegate?
    private var dataSource: Datasource!
    private let mockCategoryData: [MockCategoryData] = [
        MockCategoryData(text: "자취생 필수!", color: .mainColor ?? .white, img: UIImage(named: "homealone_svg")!),
        MockCategoryData(text: "다이어터를\n위한 레시피", color: .sub3 ?? .white, img: UIImage(named: "diet_svg")!),
        MockCategoryData(text: "알뜰살뜰\n만원의 행복", color: .sub2 ?? .white, img: UIImage(named: "manwon_svg")!),
        MockCategoryData(text: "집들이용\n레시피", color: .sub4 ?? .white, img: UIImage(named: "homeparty_svg")!)]
    
    private let mockRecipeData: [Recipe] = [
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란 볶밥", cookTime: "10분", rate: "4.7(104)", isFavorite: true),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토", cookTime: "10분", rate: "4.7(104)", isFavorite: false),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란", cookTime: "10분", rate: "4.7(104)", isFavorite: true),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란 볶음밥", cookTime: "10분", rate: "4.7(104)", isFavorite: true),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란 볶음밥을", cookTime: "10분", rate: "4.7(104)", isFavorite: true),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란 볶음밥을 먹어요", cookTime: "10분", rate: "4.7(104)", isFavorite: false),
        Recipe(image: UIImage(named: "recipeDetail")!, uploadTime: "3분전", nickName: "규땡뿡야", title: "토마토 계란 볶음밥좋아", cookTime: "10분", rate: "4.7(104)", isFavorite: true),
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
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(51.57)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.right.equalTo(searchTextField).inset(15)
            $0.centerY.equalTo(searchTextField)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
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
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(85)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(85)), subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 5)
//        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func createRecipeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
        item.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        
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
        ForRecipeView().ignoresSafeArea()
    }
}
#endif
