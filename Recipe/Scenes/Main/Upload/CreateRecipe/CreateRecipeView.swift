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
import RxKeyboard

struct Dummy: Hashable {
    let id = UUID()
    let contents: String
    var img: UIImage?
}

protocol CreateRecipeViewDelegate: AnyObject {
    func registerButtonTapped( _ item: UploadRecipe) async
    func addPhotoButtonTapped()
    func addIngredientCellTapped(_ item: IngredientInfo)
    func addThumbnailButtonTapped()
    func thumbnailModifyButtonTapped()
}
final class CreateRecipeView: UIView, DefaultTextFieldCellDelegate {
    func didTappedCell(_ item: IngredientInfo) {
        delegate?.addIngredientCellTapped(item)
    }
    
    enum Section: Hashable {
        case thumbnailSection
        case recipeNameSection
        case recipeDescriptSection
        case recipeIngredientSection
        case addIngredientSection
        case cookTimeSettingSection
        case cookStepSection
    }
    
    enum Item: Hashable {
        case thumbnailSection
        case recipeNameSection
        case recipeDiscriptSection
        case recipeIngredientSection
        case addIngredientSection(String)
        case cookTimeSettingSection
        case cookStepSection(Dummy)
    }
    
    enum A: Hashable {
        case cookStepSection(Dummy)
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
        v.setTitle("등록dla", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .grayScale3
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        //        v.isEnabled = false
        return v
    }()
    
    /// Properties
    var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    weak var delegate: CreateRecipeViewDelegate?
    private var mockData: [Dummy] = [Dummy(contents: "", img: UIImage())]
    //    var addIngredientMockData: [String] = []
    //    var addIngredientMockData = BehaviorRelay<[String]>(value: [])
    
    //    var thumbnailImage = BehaviorRelay<UIImage?>(value:nil)
    //    let imageRelay = PublishRelay<UIImage>()
    //    let imageBehaviorRelay = BehaviorRelay<UIImage>(value: UIImage(named: "popcat")!)
    var mymy: UploadRecipe?
    var mybool = false
    var viewModel: CreateRecipeViewModel? {
        didSet {
            Task {
                await setViewModel()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        registerCell()
        configureDataSource()
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
            guard let self = self else { return }
            for sectionTransaction in transaction.sectionTransactions {
                let sectionIdentifier = sectionTransaction.sectionIdentifier
                switch sectionIdentifier {
                case .cookStepSection:
                    var myData = [Dummy]()
                    for a in sectionTransaction.finalSnapshot.items {
                        switch a {
                        case .cookStepSection(let data):
                            myData.append(data)
                        default:
                            return
                        }
                    }
                    self.mockData = myData
                default:
                    return
                    
                }
            }
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
        addSubViews(collectionView, registerButton)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func registerCell() {
        collectionView.registerCell(cellType: CreateRecipeHeaderCell.self)
        collectionView.registerCell(cellType: TextFieldCell.self)
        collectionView.registerCell(cellType: TextFieldViewCell.self)
        collectionView.registerCell(cellType: CookSettingCell.self)
        collectionView.registerCell(cellType: DefaultTextFieldCell.self)
        collectionView.registerCell(cellType: CookStepCell.self)
        collectionView.registerCell(cellType: CookStepCell2.self)
        collectionView.registerCell(cellType: CreateIngredientTagCell.self)
        
        collectionView.registerHeaderView(viewType: DefaultHeader.self)
        collectionView.registerHeaderView(viewType: CookStepHeaderView.self)
        collectionView.registerHeaderView(viewType: CookStepCountCell.self)
        
        collectionView.registerFooterView(viewType: CookStepFooterView.self)
    }
    
    func setViewModel() async {
        print(#function)
        if let viewModel {
            await viewModel.getData()
        }
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        
        if let originalImage = UIImage(named: "delete_svg"),
           let resizedImage = originalImage.resized(to: CGSize(width: 30, height: 30)) {
            
            let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
                print("id:", id)
                self?.deleteItem(id, idx: indexPath)
                completion(false)
            }
            
            deleteAction.image = resizedImage
            deleteAction.backgroundColor = .white
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return nil
    }
    
    private func deleteItem(_ item: Item, idx: IndexPath) {
        guard case let .cookStepSection(dummyData) = item else { return }
        var snapShot = dataSource.snapshot()
        snapShot.deleteItems([item])
        
        if let index = mockData.firstIndex(of: dummyData) {
            mockData.remove(at: index)
        }
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 100, trailing: 10)
                section.interGroupSpacing = 10
                
                
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                section.boundarySupplementaryItems = [header,footer]
                
                return section
            default:
                return self.sectionFor(index: index, environment: env)
            }
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .thumbnailSection:
            return createThumbnailSection()
        case .recipeNameSection, .cookTimeSettingSection:
            return createEqualSize()
        case .recipeIngredientSection:
            return createIngredientSection()
        case .addIngredientSection:
            return createAddIngredientSection()
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
    
    func createThumbnailSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.22)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        
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
        return mybool ? 120 : 50
    }
    
    
    func createIngredientSection() -> NSCollectionLayoutSection {
        let sectionHeight = self.calculateSectionHeight()
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(sectionHeight)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(sectionHeight)),
            subitem: item,
            count: 1)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
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
    
    func createAddIngredientSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.3),
                heightDimension: .absolute(50)),
            subitems: [item])
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
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
        case .thumbnailSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateRecipeHeaderCell.reuseIdentifier, for: indexPath) as! CreateRecipeHeaderCell
            cell.addThumbnailButton.rx.tap
                .subscribe(onNext: { _ in
                    self.delegate?.addThumbnailButtonTapped()
                }).disposed(by: disposeBag)
            cell.modifyButton.rx.tap
                .subscribe(onNext: { _ in
                    self.delegate?.thumbnailModifyButtonTapped()
                }).disposed(by: disposeBag)
            if let viewModel {
                viewModel.thumbnailImage
                    .debug()
                    .subscribe(onNext: { img in
                        if let img {
                            print("???")
                            DispatchQueue.main.async {
                                cell.thumbnailBackground.image = img
                                cell.hasImage()
                                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
                            }
                        }
                    }).disposed(by: disposeBag)
            }
            return cell
        case .recipeNameSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(text: "레시피 이름을 입력해주세요", needSearchButton: false)
            if let viewModel {
                cell.recipeNametextField.rx.text.orEmpty
                    .subscribe(onNext: { txt in
                        if !txt.isEmpty {
                            viewModel.createRecipeTitle.accept(txt)
                        }
                    }).disposed(by: disposeBag)
            }
            return cell
        case .recipeDiscriptSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldViewCell.reuseIdentifier, for: indexPath) as! TextFieldViewCell
            if let viewModel {
                cell.textView.rx.text.orEmpty
                    .skip(1)
                    .subscribe(onNext: { txt in
                        if !txt.isEmpty {
                            viewModel.createRecipeDescription.accept(txt)
                        }
                    }).disposed(by: disposeBag)
            }
            return cell
        case .recipeIngredientSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultTextFieldCell.reuseIdentifier, for: indexPath) as! DefaultTextFieldCell
            
            if let viewModel {
                viewModel.ingredient.subscribe(onNext: { ingredient in
                    print(ingredient)
                    cell.confifgure(ingredient)
                }).disposed(by: disposeBag)
            }
            
            cell.configure(text: "재료 및 양념을 입력해주세요.")
            cell.delegate = self
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
        case .addIngredientSection(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateIngredientTagCell.reuseIdentifier, for: indexPath) as! CreateIngredientTagCell
            cell.configure(with: data, tag: indexPath.row)
            return cell
        case .cookTimeSettingSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookSettingCell.reuseIdentifier, for: indexPath) as! CookSettingCell
            if let viewModel {
                cell.cookTimeTextField.rx.text.orEmpty
                    .subscribe(onNext: { txt in
                        if let intValue = Int(txt) {
                            viewModel.createRecipeCookTime.accept(intValue)
                        }
                    }).disposed(by: disposeBag)
                
                cell.serviceCountRx
                    .debug()
                    .subscribe(onNext: { count in
                        DispatchQueue.main.async {
                            cell.serviceCountLabel.text = "\(count)"
                        }
                        viewModel.createRecipeServiceCount.accept(count)
                    })
                    .disposed(by: disposeBag)
                
//                cell.serviceCountRx
//                    .skip(1)
//                    .subscribe(onNext: { value in
//                    viewModel.createRecipeServiceCount.accept(value)
//                }).disposed(by: disposeBag)
                
//                viewModel.allValuesSubject
//                    .distinctUntilChanged()
//                    .subscribe(onNext: { (_,_,_,data,service,_) in
//                        print("cooTime 추적: \(data)")
//                        DispatchQueue.main.async {
//                            cell.cookTimeTextField.text = "\(data)"
//                            cell.serviceCountLabel.text = "\(service)"
//                            cell.serviceCountRx.accept(service)
//                        }
//                    }).disposed(by: disposeBag)
            }
            return cell
        case .cookStepSection(let data):
            if let viewModel {
                if data.contents == "" {
                    // Show a different cell when the array is empty
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookStepCell2.reuseIdentifier, for: indexPath) as! CookStepCell2
                    cell.selectImageView.image = nil
                    setupKeyboardForCell(cell: cell, textField: cell.stepTextfield)
                    viewModel.imageRelay.subscribe(onNext: { data in
                        cell.imageSelectSubject.accept(data)
                    }).disposed(by: cell.disposeBag)
                    
                    cell.addPhotoButton.rx.tap
                        .subscribe(onNext: { _ in
                            self.delegate?.addPhotoButtonTapped()
                        }).disposed(by: cell.disposeBag)
                    
                    cell.stepTextfield.rx.controlEvent(.editingDidEndOnExit)
                        .subscribe(onNext: { [weak self, weak cell] _ in
                            guard let self = self, let cell = cell, let newText = cell.stepTextfield.text else { return }
                            if newText.isEmpty {
                                // Skip empty text
                                return
                            }
                            let newStep = Dummy(contents: newText, img: viewModel.imageBehaviorRelay.value)
                            if !self.mockData.contains(newStep) {
                                self.mockData.insert(newStep, at: self.mockData.count)
//                                self.mockData.append(newStep)
                            }
                            let data = Dummy(contents: "")
                            for (idx,item) in self.mockData.enumerated() {
                                if item.contents.isEmpty {
                                    self.mockData.remove(at: idx)
                                }
                            }
                            print("첫번째를 제거했을 때:::", self.mockData)
                            if let dataiExist = self.mockData.last, dataiExist.contents.isEmpty {
                                print("이미 존재함")
                            } else {
                                self.mockData.append(data)
                                print("마지막으로 추가했을 때:::", self.mockData)
                            }
                            //                        self.mockData.insert(newStep, at: 0)
                            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
                            self.applyNewSnapshot()
                            cell.stepTextfield.text = ""
                            viewModel.imageBehaviorRelay.accept(nil)
                            if let initialIndexPath = self.dataSource.indexPath(for: .cookStepSection(self.mockData.last!)) {
                                collectionView.scrollToItem(at: initialIndexPath, at: .bottom, animated: true)
                            }
                        }).disposed(by: cell.disposeBag)
                    
                    return cell
                } else {
                    // Show the CookStepCell when the array has values
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookStepCell.reuseIdentifier, for: indexPath) as! CookStepCell
                    cell.accessories = [.reorder(displayed: .always), .delete()]
                    //                imageBehaviorRelay.subscribe(onNext: { data in
                    //                    cell.imageSelectSubject.accept(data)
                    //                }).disposed(by: disposeBag)
                    cell.selectImageView.image = nil
                    cell.addPhotoButton.rx.tap
                        .subscribe(onNext: { _ in
                            self.delegate?.addPhotoButtonTapped()
                        }).disposed(by: disposeBag)
                    cell.deletePhotoButton.rx.tap
                        .subscribe(onNext: { _ in
                            print(indexPath.row)
                            var data = self.mockData[indexPath.row]
                            data.img = UIImage(named: "popcat")
                            self.mockData[indexPath.row] = data
                            cell.configure(data)
                            self.dataSource.apply(self.createSnapshot(),animatingDifferences: true)
                            print(data)
                        }).disposed(by: disposeBag)
                    
                    cell.defaultCheck.accept(false)
                    cell.configure(data)
                    setupKeyboardForCell(cell: cell, textView: cell.stepTextView)
                    print(data)
                    return cell
                }
            }
            return UICollectionViewCell()
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .thumbnailSection, .addIngredientSection:
            return UICollectionReusableView()
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
                headerView.configureTitleCount(text: "조리 단계", count: mockData.count - 1)
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CookStepFooterView.identifier, for: indexPath) as! CookStepFooterView
                footerView.delegate = self
                if let viewModel {
                    viewModel.uploadCheck
                        .distinctUntilChanged()
                        .subscribe(onNext: { isSuccess in
                        print(isSuccess)
                        if isSuccess {
                            footerView.registerButton.isEnabled = true
                            footerView.registerButton.backgroundColor = .mainColor
                        } else {
                            footerView.registerButton.isEnabled = false
                            footerView.registerButton.backgroundColor = .grayScale3
                        }
                    }).disposed(by: disposeBag)
                    
                    viewModel.allValuesSubject
                        .subscribe(onNext: { values in
                        Task {
                            let (image, title, description, cookTime, serviceCount, ingredients) = values
                            // Handle the values here
                            if self.mockData.count > 1 {
                                var array = self.mockData.dropLast()
                                var step: [RecipeUploadForStep] = []
                                
                                // This loop also seems to have potential for heavy operations due to the image-to-base64 conversion
                                for value in array {
                                    let contents = value.contents
                                    if let img = value.img?.toBase64() {
                                        let stepData = RecipeUploadForStep(image_url: img, stage_description: contents)
                                        step.append(stepData)
                                    } else {
                                        let stepData = RecipeUploadForStep(image_url: nil, stage_description: contents)
                                        step.append(stepData)
                                    }
                                }
                                if let img = image?.toBase64()  {
                                    
                                    // Continue processing on main thread
                                    let data = UploadRecipe(cook_time: cookTime,
                                                            ingredients: ingredients,
                                                            recipe_description: description,
                                                            recipe_name: title,
                                                            recipe_stages: step,
                                                            recipe_thumbnail_img: img,
                                                            serving_size: serviceCount)
                                    viewModel.upload.accept(data)
                                    viewModel.uploadCheck.accept(true)
                                    self.mymy = data
                                    
                                }
                                
                            }
                        }
                    }).disposed(by: disposeBag)
                }
                return footerView
            }
            
        }
    }
    
    func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([
            .thumbnailSection,
            .recipeNameSection,
            .recipeDescriptSection,
            .recipeIngredientSection,
            .addIngredientSection,
            .cookTimeSettingSection,
            .cookStepSection])
        snapshot.appendItems([.thumbnailSection], toSection: .thumbnailSection)
        snapshot.appendItems([.recipeNameSection], toSection: .recipeNameSection)
        snapshot.appendItems([.recipeDiscriptSection], toSection: .recipeDescriptSection)
        snapshot.appendItems([.recipeIngredientSection], toSection: .recipeIngredientSection)
        snapshot.appendItems([.cookTimeSettingSection], toSection: .cookTimeSettingSection)
        snapshot.appendItems(mockData.map { Item.cookStepSection($0)}, toSection: .cookStepSection)
        if let viewModel {
            snapshot.appendItems(viewModel.createRecipeIngredient.value.map { Item.addIngredientSection($0)}, toSection: .addIngredientSection)
        }
        
        return snapshot
    }
}

extension CreateRecipeView: CookStepRegisterDelegate {
    func didTappedRegisterButton() {
        print(#function)
        guard let a = self.mymy else { return }
        Task {
            await self.delegate?.registerButtonTapped(a)
        }
    }
}

//MARK: - Method(Rx Bind)
extension CreateRecipeView {
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
}

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
