//
//  ShortFormFullScreenView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit

struct Tag: Hashable {
    let id = UUID()
    let name: String
}

class ShortFormFullScreenView: UIView {
    
    enum Section: Hashable {
        case ingredient
        case shopingList
    }
    
    enum Item: Hashable {
        case ingredient(Tag)
        case shopingList(ShopingList)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    /// UI Properties
    private let shortFormbackground: UIView = {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    
    private let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormHeart"), for: .normal)
        v.setTitle("132", for: .normal)
        v.alignTextBelow(spacing: 10)
        return v
    }()
    
    let commentButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormComment"), for: .normal)
        v.setTitle("56", for: .normal)
        v.alignTextBelow(spacing: 10)
        return v
    }()
    
    private let favoriteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormFavorite"), for: .normal)
        v.setTitle("21", for: .normal)
        v.alignTextBelow(spacing: 10)
        return v
    }()
    
    private let nickNameLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .boldSystemFont(ofSize: 14)
        return v
    }()
    
    private let explanationLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        return v
    }()
    
    /// Properties
    private var dataSource: Datasource!
    
    private var mockShopList: [ShopingList] = [ShopingList(title: "대홍단 감자", price: 20000, image: UIImage(named: "popcat")!, isrocket: true),
    ShopingList(title: "전남 국내산 대추 방울", price: 13000, image: UIImage(named: "popcat")!, isrocket: false)]
    private var mockTagList: [Tag] = [Tag(name: "도레미"),
                                      Tag(name: "당근"),
                                      Tag(name: "오레오화이트초코")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        mockConfigure()
        configureDataSource()
        registerCell()
        backgroundColor = .blue
        collectionView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShortFormFullScreenView {
    func addView() {
        addSubViews(likeButton, commentButton, favoriteButton, nickNameLabel, explanationLabel, collectionView)
    }
    func configureLayout() {
        
        likeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).offset(40)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(30)
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(40)
            $0.right.width.equalTo(likeButton)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(commentButton.snp.bottom).offset(40)
            $0.right.width.equalTo(likeButton)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.top)
            $0.left.equalToSuperview().inset(20)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalTo(favoriteButton.snp.left).offset(-20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    func registerCell() {
        collectionView.register(ShortFormTagCell.self, forCellWithReuseIdentifier: ShortFormTagCell.reuseIdentifier)
        collectionView.register(ShopingListCell.self, forCellWithReuseIdentifier: ShopingListCell.reuseIdentifier)
    }
    
    func mockConfigure() {
        nickNameLabel.text = "happyday125"
        explanationLabel.text = "탕후루를 집에서 손쉽게 만드는 법을 공개합니다"
    }
}

//MARK: - Method(Comp + Diff)
extension ShortFormFullScreenView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let section = dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .ingredient:
            return createIngredientList()
        case .shopingList:
            return createShopingListSection()
        }
    }
    
    func createIngredientList() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .estimated(28)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.2)),
            subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .none
        
        
        // Return
        return section
    }
    
    func createShopingListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(115)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .groupPaging
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
        case .ingredient(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortFormTagCell.reuseIdentifier, for: indexPath) as! ShortFormTagCell
            cell.configure(data)
            return cell
        case .shopingList(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopingListCell.reuseIdentifier, for: indexPath) as! ShopingListCell
            cell.configure(data)
            return cell
        }
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.ingredient, .shopingList])
        snapshot.appendItems(mockTagList.map({ Item.ingredient($0) }), toSection: .ingredient)
        snapshot.appendItems(mockShopList.map({ Item.shopingList($0) }), toSection: .shopingList)
        return snapshot
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormFullScreenView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormFullScreenView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForShortFormFullScreenView_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormFullScreenView()
            .ignoresSafeArea()
        //            .previewLayout(.fixed(width: 250, height: 500))
    }
}
#endif
