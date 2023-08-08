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

protocol CreateRecipeViewDelegate: AnyObject {
    func registerButtonTapped()
    func addPhotoButtonTapped()
}
final class CreateRecipeView: UIView {
    enum Section: Hashable {
        case recipeNameSection
        case recipeDescriptSection
        case recipeIngredientSection
        case cookTimeSettingSection
        case cookStepSection
    }
    
    enum Item: Hashable {
        case recipeNameSection
        case recipeDiscriptSection
        case recipeIngredientSection
        case cookTimeSettingSection
        case cookStepSection(Dummy)
    }
    
    enum A: Hashable {
        case cookStepSection(Dummy)
    }
    
    struct Dummy: Hashable {
        let id = UUID()
        let contents: String
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
    
    private let registerButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .red
        return v
    }()
    
    /// Properties
    private var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    weak var delegate: CreateRecipeViewDelegate?
    private var mockData: [Dummy] = []
    let imageRelay = PublishRelay<UIImage>()
    var mybool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        registerCell()
        configureDataSource()
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        dataSource.reorderingHandlers.didReorder = { transaction in
            // 구현
        }
        collectionView.delegate = self
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
        collectionView.registerCell(cellType: TextFieldCell.self)
        collectionView.registerCell(cellType: TextFieldViewCell.self)
        collectionView.registerCell(cellType: CookSettingCell.self)
        collectionView.registerCell(cellType: DefaultTextFieldCell.self)
        collectionView.registerCell(cellType: CookStepCell.self)

        collectionView.registerHeaderView(viewType: DefaultHeader.self)
        collectionView.registerHeaderView(viewType: CookStepHeaderView.self)
        collectionView.registerHeaderView(viewType: CookStepCountCell.self)

        collectionView.registerFooterView(viewType: CreateRecipeFooter.self)
        collectionView.registerFooterView(viewType: CookStepFooterView.self)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] a, b, completion in
            print("id:", id)
            self?.deleteItem(id, idx: indexPath)
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteItem(_ item: Item, idx: IndexPath) {
        var snapShot = dataSource.snapshot()
        snapShot.deleteItems([item])
        mockData.remove(at: 0)
        dataSource.apply(snapShot, animatingDifferences: true)
        applyNewSnapshot()
    }
    
    /// 조리단계의 리스트 셀을 추가하거나 삭제할 때 헤더의 카운트를 조절 하는 함수 입니다.
    private func applyNewSnapshot() {
        print(#function)
        var newSnapshot = self.dataSource.snapshot()
        if #available(iOS 15.0, *) {
            self.dataSource.applySnapshotUsingReloadData(newSnapshot)
        } else {
            newSnapshot.reloadSections([.cookStepSection])
            self.dataSource.apply(newSnapshot, animatingDifferences: false)
        }
    }
}
//MARK: Comp + Diff
extension CreateRecipeView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            let section = dataSource.snapshot().sectionIdentifiers[index]
            switch section {
            case .cookStepSection:
                var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                configuration.headerMode = .supplementary
                configuration.footerMode = .supplementary
                configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
                configuration.showsSeparators = false
                    
                
                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                return section
            default:
                return self.sectionFor(index: index, environment: env)
            }
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .recipeNameSection, .cookTimeSettingSection:
            return createEqualSize()
        case .recipeIngredientSection:
            return aa()
        case .recipeDescriptSection:
            return createRecipeDescription()
        case .cookStepSection:
            return createCookStepSection()
        }
    }
    
    func createRecipeDescription() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)),
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
    
    func calculateSectionHeight() -> CGFloat {
        return mybool ? 100 : 50
    }
    
    
    func aa() -> NSCollectionLayoutSection {
        let sectionHeight = self.calculateSectionHeight()
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(sectionHeight)))
//        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(sectionHeight)),
            subitem: item,
            count: 1)
        group.interItemSpacing = .fixed(10)
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
    
    func createCookStepSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.7)),
            subitems: [item])
        
        //        let grups = NSCollectionLayoutGroup.
        //        ,
        //            count: mockData.count)
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [header, footer]
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
        case .recipeNameSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(text: "레시피 이름을 입력해주세요", needSearchButton: false)
            return cell
        case .recipeDiscriptSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldViewCell.reuseIdentifier, for: indexPath) as! TextFieldViewCell
            return cell
        case .recipeIngredientSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultTextFieldCell.reuseIdentifier, for: indexPath) as! DefaultTextFieldCell
            cell.configure(text: "재료 및 양념을 입력해주세요.")
            cell.recipeNametextField.rx.text.orEmpty
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .subscribe(onNext: { txt in
                    if cell.filteredData.isEmpty {
                        self.mybool = false
                    } else {
                        self.mybool = true
                    }
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.layoutIfNeeded()
                }).disposed(by: disposeBag)
            return cell
        case .cookTimeSettingSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookSettingCell.reuseIdentifier, for: indexPath) as! CookSettingCell
            return cell
        case .cookStepSection(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookStepCell.reuseIdentifier, for: indexPath) as! CookStepCell
            cell.accessories = [.reorder(displayed: .always), .delete()]
            imageRelay.subscribe(onNext: { data in
                cell.imageSelectSubject.accept(data)
            }).disposed(by: disposeBag)
            
            cell.addPhotoButton.rx.tap
                .subscribe(onNext: { _ in
                    self.delegate?.addPhotoButtonTapped()
                }).disposed(by: disposeBag)
            
            if data.contents.isEmpty {
                cell.defaultCheck.accept(true)
            } else {
                cell.defaultCheck.accept(false)
            }
            
            cell.configure(text: data.contents)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .recipeNameSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "레시피 이름")
            return headerView
        case .recipeDescriptSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "레시피 설명")
            return headerView
        case .recipeIngredientSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeader.identifier, for: indexPath) as! DefaultHeader
            headerView.configureTitle(text: "재료/양념")
            return headerView
        case .cookTimeSettingSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CookStepHeaderView.identifier, for: indexPath) as! CookStepHeaderView
            //            headerView.configureTitle(text: "조리 시간 분")
            headerView.configureDoubleTitle(text: "조리시간", text2: "인분")
//            headerView.highlightTextColor()
            return headerView
        case .cookStepSection:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CookStepCountCell.identifier, for: indexPath) as! CookStepCountCell
                headerView.configureTitleCount(text: "조리 단계", count: mockData.count)
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CookStepFooterView.identifier, for: indexPath) as! CookStepFooterView
                
                imageRelay.subscribe(onNext: { data in
                    footerView.imageSelectSubject.accept(data)
                }).disposed(by: disposeBag)
                
                footerView.addPhotoButton.rx.tap
                    .subscribe(onNext: { _ in
                        self.delegate?.addPhotoButtonTapped()
                    }).disposed(by: disposeBag)
                
                footerView.stepTextfield.rx.controlEvent(.editingDidEndOnExit)
                    .subscribe(onNext: { _ in
                        //                    cell.
                        self.mockData.insert(Dummy(contents: footerView.stepTextfield.text ?? ""), at: 0)
                        self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
                        self.applyNewSnapshot()
                    }).disposed(by: disposeBag)
//                footerView.registerButton.rx.tap
//                    .subscribe(onNext: { _ in
//                        self.delegate?.registerButtonTapped()
//                    }).disposed(by: disposeBag)
                return footerView
            }
            
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.recipeNameSection, .recipeDescriptSection, .recipeIngredientSection ,.cookTimeSettingSection, .cookStepSection])
        snapshot.appendItems([.recipeNameSection], toSection: .recipeNameSection)
        snapshot.appendItems([.recipeDiscriptSection], toSection: .recipeDescriptSection)
        snapshot.appendItems([.recipeIngredientSection], toSection: .recipeIngredientSection)
        snapshot.appendItems([.cookTimeSettingSection], toSection: .cookTimeSettingSection)
        snapshot.appendItems(mockData.map { Item.cookStepSection($0)}, toSection: .cookStepSection)
        
        return snapshot
    }
}

//MARK: - Method(Rx Bind)


extension CreateRecipeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if originalIndexPath.section != proposedIndexPath.section {
            return originalIndexPath
        }
        return proposedIndexPath
    }
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
