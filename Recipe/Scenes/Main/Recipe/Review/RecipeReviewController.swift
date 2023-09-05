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

protocol RecipeReviewControllerDelegate: AnyObject {
    func didTapMorePhotoButton(_ item: [String])
}

class RecipeReviewController: BaseViewController, ReviewCellPhotoDelegate {
    func likeButtonTapped() {
        print("")
    }
    
    func singoButtonTapped() {
        print("")
    }
    
    func reviewPhotoSend(_ item: [String]) {
        self.delegate?.didTapMorePhotoButton(item)
    }
    
    var didSendEventClosure: ((RecipeReviewController.Event) -> Void)?
    
    enum Event {
        case go
    }
    
    enum Section: Hashable {
        case header
        case review
    }
    
    enum Item: Hashable {
        case header
        case review(ReviewInfo)
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
    weak var delegate: RecipeReviewControllerDelegate?
    private var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    private let viewModel = ReviewViewModel()
    var recipeId: Int
    private var mockData: [ReviewInfo] = []
    var counting = PublishRelay<Int>()
    
    init(recipeId: Int) {
        self.recipeId = recipeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        Task {
            await viewModel.setData(recipeId)
        }
        
        viewModel.review.subscribe(onNext: { value in
            self.mockData = value.data.content
            self.counting.accept(self.mockData.count)
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }).disposed(by: disposeBag)
    }
}

//MARK: - Method(Normal)
extension RecipeReviewController {
    
    func registerCell() {
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)
        collectionView.register(RecipeDetailReviewHeader.self, forCellWithReuseIdentifier: RecipeDetailReviewHeader.reuseIdentifier)
        collectionView.register(ReviewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewHeader.identifier)
    }
}

//MARK: - Method(Comp + Diff)
extension RecipeReviewController {
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
        case .review:
            return createCookStepSection()
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(261)))
        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(261)), subitems: [headerItem])
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    func createCookStepSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)))
        //        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 10)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: .fixed(3))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)),
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
            viewModel.reviewStar.subscribe(onNext: {reviewData in
                print("reviewData::", reviewData)
                cell.configure(reviewData)
            }).disposed(by: disposeBag)
            viewModel.photos.subscribe(onNext: {photos in
                print("photos::", photos)
                cell.configurePhoto(photos)
            }).disposed(by: disposeBag)
            
            cell.delegate = self
            return cell
        case .review(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as! ReviewCell
            cell.photoDelegate = self
            cell.configure(data)
            
            cell.likeButton.rx.tap
                .subscribe(onNext: { _ in
                    print("reviewID : \(data.review_id)")
                    if !cell.likeCheck {
                        Task {
                            let result: ReviewResult = try await NetworkManager.shared.get(.likeReview("\(data.review_id)"))
                            if result.code == "SUCCESS" {
                                cell.likeCheck = true
                                DispatchQueue.main.async {
                                    cell.likeButton.setImage(UIImage(named: "heart_review_fill_svg"), for: .normal)
                                    cell.likeButton.setTitle("\(data.like_count + 1)", for: .normal)
                                    cell.likeButton.setTitleColor(.mainColor, for: .normal)
                                }
                            }
                        }
                    } else {
                        Task {
                            let result: ReviewResult = try await NetworkManager.shared.get(.unlikeReview("\(data.review_id)"))
                            if result.code == "SUCCESS" {
                                cell.likeCheck = false
                                DispatchQueue.main.async {
                                    cell.likeButton.setImage(UIImage(named: "heart_review_svg"), for: .normal)
                                    if let count = cell.likeButton.titleLabel?.text {
                                        cell.likeButton.setTitle("\(Int(count)! - 1)", for: .normal)
                                        cell.likeButton.setTitleColor(.grayScale3, for: .normal)
                                    }
                                }
                            }
                        }
                    }
                }).disposed(by: disposeBag)
            
            cell.singoButton.rx.tap
                .subscribe(onNext: { _ in
                    Task {
                        let result: ReviewResult = try await NetworkManager.shared.get(.banReview("\(data.review_id)"))
                        if result.code == "SUCCESS" {
                            if let index = self.mockData.firstIndex(where: { $0.review_id == data.review_id }) {
                                self.mockData.remove(at: index)
                                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
                                self.showToastSuccess(message: "신고가 접수되었습니다")
                            }
                        }
                    }
                }).disposed(by: disposeBag)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: Section) -> UICollectionReusableView {
        switch section {
        case .header:
            return UICollectionReusableView()
        case .review:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReviewHeader.identifier, for: indexPath) as! ReviewHeader
//            viewModel.review.subscribe(onNext: { value in
//                self.mockData = value.data.content
//                headerView.configure(self.mockData.count)
//                self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
//            }).disposed(by: disposeBag)
//            headerView.configure(mockData.count)
            
            counting.subscribe(onNext: {count in
                headerView.configure(self.mockData.count)
            }).disposed(by: disposeBag)
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

extension RecipeReviewController: RecipeDetailReviewHeaderDelegate {
    func didTappedMorePhotoButton(_ item: [String]) {
        //        didSendEventClosure?(.go)
        print(#function)
        delegate?.didTapMorePhotoButton(item)
    }
}

//MARK: - VC Preview
import SwiftUI
struct RecipeReviewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: RecipeReviewController(recipeId: 0)).toPreview()
    }
}
