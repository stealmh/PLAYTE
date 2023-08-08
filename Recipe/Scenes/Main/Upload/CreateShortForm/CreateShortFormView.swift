//
//  CreateShortFormView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard


final class CreateShortFormView: UIView {
    enum Section: Hashable {
        case addVideoSection
        case recipeNameSection
        case recipeDescriptSection
        case recipeIngredientSection
    }
    
    enum Item: Hashable {
        case addVideoSection
        case recipeNameSection
        case recipeDiscriptSection
        case recipeIngredientSection
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
    let imageRelay = PublishRelay<UIImage>()
    var mybool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
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
extension CreateShortFormView {
    
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
        collectionView.registerCell(cellType: CreateShortFormVideoHeaderCell.self)
        collectionView.registerCell(cellType: TextFieldCell.self)
        collectionView.registerCell(cellType: TextFieldViewCell.self)
        collectionView.registerCell(cellType: DefaultTextFieldCell.self)
        
        collectionView.registerHeaderView(viewType: DefaultHeader.self)
    }
}
//MARK: Comp + Diff
extension CreateShortFormView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .addVideoSection:
            return createVideoSection()
        case .recipeNameSection:
            return createRecipeNameSection()
        case .recipeIngredientSection:
            return createRecipeIngredientSection()
        case .recipeDescriptSection:
            return createRecipeDescription()
        }
    }
    
    func createVideoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(360)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 80)
        
        
        // Return
        return section
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
    
    func createRecipeNameSection() -> NSCollectionLayoutSection {
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
    
    
    func createRecipeIngredientSection() -> NSCollectionLayoutSection {
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
        case .addVideoSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateShortFormVideoHeaderCell.reuseIdentifier, for: indexPath) as! CreateShortFormVideoHeaderCell
            return cell
        case .recipeNameSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(text: "레시피 이름을 입력해주세요", needSearchButton: false)
            setupKeyboardForCell(cell: cell, textField: cell.recipeNametextField)
            return cell
        case .recipeDiscriptSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldViewCell.reuseIdentifier, for: indexPath) as! TextFieldViewCell
            setupKeyboardForCell(cell: cell, textView: cell.textView)
            return cell
        case .recipeIngredientSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultTextFieldCell.reuseIdentifier, for: indexPath) as! DefaultTextFieldCell
            cell.configure(text: "재료 및 양념을 입력해주세요.")
            setupKeyboardForCell(cell: cell, textField: cell.recipeNametextField)
            setupAdditionalBehaviorForIngredientCell(cell)
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
        case .addVideoSection:
            return UICollectionReusableView()
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.addVideoSection, .recipeNameSection, .recipeDescriptSection, .recipeIngredientSection])
        snapshot.appendItems([.addVideoSection], toSection: .addVideoSection)
        snapshot.appendItems([.recipeNameSection], toSection: .recipeNameSection)
        snapshot.appendItems([.recipeDiscriptSection], toSection: .recipeDescriptSection)
        snapshot.appendItems([.recipeIngredientSection], toSection: .recipeIngredientSection)
        
        return snapshot
    }
}

//MARK: - Method(Rx Bind)
extension CreateShortFormView {
    private func setupKeyboardForCell(cell: UICollectionViewCell, textField: UITextField) {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                
                // 키보드 높이만큼 contentInset을 조정
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardVisibleHeight, right: 0.0)
                self.collectionView.contentInset = contentInsets
                self.collectionView.scrollIndicatorInsets = contentInsets
                
                // 필요한 경우, 특정 텍스트 필드나 컨트롤 뷰가 키보드에 의해 가려지지 않게 스크롤 조정
                let selectedTextField = textField
                let rect = selectedTextField.convert(selectedTextField.bounds, to: self.collectionView)
                    self.collectionView.scrollRectToVisible(rect, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboardForCell(cell: UICollectionViewCell, textView: UITextView) {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                
                // 키보드 높이만큼 contentInset을 조정
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardVisibleHeight, right: 0.0)
                self.collectionView.contentInset = contentInsets
                self.collectionView.scrollIndicatorInsets = contentInsets
                
                // 필요한 경우, 특정 텍스트 필드나 컨트롤 뷰가 키보드에 의해 가려지지 않게 스크롤 조정
                let selectedTextView = textView
                let rect = selectedTextView.convert(selectedTextView.bounds, to: self.collectionView)
                    self.collectionView.scrollRectToVisible(rect, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupAdditionalBehaviorForIngredientCell(_ cell: DefaultTextFieldCell) {
        cell.recipeNametextField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] txt in
                if cell.filteredData.isEmpty {
                    self?.mybool = false
                } else {
                    self?.mybool = true
                }
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
}


extension CreateShortFormView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if originalIndexPath.section != proposedIndexPath.section {
            return originalIndexPath
        }
        return proposedIndexPath
    }
}

import SwiftUI
struct ForCreateShortFormView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CreateShortFormView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CreateShortFormView_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateShortFormView()
    }
}
