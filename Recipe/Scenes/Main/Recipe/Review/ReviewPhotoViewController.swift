//
//  ReviewPhotoViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Photo: Hashable {
    let id = UUID()
    let image: UIImage
}

class ReviewPhotoViewController: BaseViewController {
    
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case main(Photo)
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
    private var mockData: [Photo] = [Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!),
                                     Photo(image: UIImage(named: "popcat")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        registerCell()
        configureDataSource()
        let v = UILabel()
        v.text = "사진 리뷰 \(mockData.count)"
        v.textColor = .mainColor
        v.font = .boldSystemFont(ofSize: 16)
        v.asColor(targetString: "사진 리뷰", color: .black)
        navigationItem.titleView = v
    }
}

//MARK: - Method(Normal)
extension ReviewPhotoViewController {
    
    func registerCell() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
    }
}

//MARK: - Method(Comp + Diff)
extension ReviewPhotoViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
                return self.sectionFor(index: index, environment: env)
//            }
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .main:
            return createCookStepSection()
        }
    }
    func createCookStepSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)),
            subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .none
        
        
        // Return
        return section
    }
    
    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell{
        switch item {
        case .main(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
            cell.configure(data)
            return cell
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(mockData.map { Item.main($0) }, toSection: .main)

        
        return snapshot
    }
}

//MARK: - VC Preview
import SwiftUI
struct ReviewPhotoViewController_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: ReviewPhotoViewController()).toPreview()
    }
}
