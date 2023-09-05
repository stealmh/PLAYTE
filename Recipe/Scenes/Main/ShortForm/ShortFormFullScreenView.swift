//
//  ShortFormFullScreenView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
        v.backgroundColor = .black
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    
    private let likeButton: ExtendedTouchAreaButton = {
        let v = ExtendedTouchAreaButton()
        v.setImage(UIImage(named: "heart_svg"), for: .normal)
        v.setTitle("0", for: .normal)
        v.alignTextBelow(spacing: 10)
        v.titleLabel?.textAlignment = .center
        return v
    }()
    
    let commentButton: ExtendedTouchAreaButton = {
        let v = ExtendedTouchAreaButton()
        v.setImage(UIImage(named: "comment_svg"), for: .normal)
        v.setTitle("11", for: .normal)
        v.alignTextBelow(spacing: 10)
        v.titleLabel?.textAlignment = .center
        return v
    }()
    
    private let favoriteButton: ExtendedTouchAreaButton = {
        let v = ExtendedTouchAreaButton()
        v.setImage(UIImage(named: "favorite_svg"), for: .normal)
        v.setTitle("0", for: .normal)
        v.alignTextBelow(spacing: 10)
        v.titleLabel?.textAlignment = .center
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
    private let disposeBag = DisposeBag()
    
//    private var mockShopList: [ShopingList] = [ShopingList(title: "대홍단 감자", price: 20000, image: UIImage(named: "popcat")!, isrocket: true),
//    ShopingList(title: "전남 국내산 대추 방울", price: 13000, image: UIImage(named: "popcat")!, isrocket: false)]
    private var mockShopList: [ShopingList] = [ShopingList(title: "1", price: 0, image: "https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2019/05/08/16/9/89441172-dc5e-49b6-8fb9-3b5b4216aabe.jpg", isrocket: true, link: "")]
    private var mockTagList: [Tag] = []
    
    var getItemRelay = PublishRelay<ShortFormInfo>()
    var item: ShortFormInfo
    
    init(item: ShortFormInfo) {
        self.item = item
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addView()
        configureLayout()
        mockConfigure()
        configureDataSource()
        registerCell()
        collectionView.delegate = self
        backgroundColor = .blue
        collectionView.backgroundColor = .clear
//        likeButton.backgroundColor = .red
        favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapSaveButton { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            let imageName = (action == "cancel") ? "favorite_svg" : "favoriteFill_svg"
                            self?.favoriteButton.setImage(UIImage(named: imageName), for: .normal)

                            // 2. Adjust the count
                            if let txt = self?.favoriteButton.titleLabel?.text, let count = Int(txt) {
                                let updatedCount = (action == "cancel") ? count - 1 : count + 1
                                self?.favoriteButton.setTitle("\(updatedCount)", for: .normal)
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("shortformCell tapped")
                
                self?.didTapLikeButton { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            let imageName = (action == "cancel") ? "heart_svg" : "heartFill_svg"
                            self?.likeButton.setImage(UIImage(named: imageName), for: .normal)

                            // 2. Adjust the count
                            if let txt = self?.likeButton.titleLabel?.text, let count = Int(txt) {
                                let updatedCount = (action == "cancel") ? count - 1 : count + 1
                                self?.likeButton.setTitle("\(updatedCount)", for: .normal)
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        
        getItemRelay.subscribe(onNext: { item in
            print("get Item Relay")
            self.mockShopList = []
            self.mockTagList = []
            for ingredient in item.ingredients {
                let convert: ShopingList = ShopingList(title: ingredient.coupang_product_name,
                                                       price: ingredient.coupang_product_price,
                                                       image: ingredient.coupang_product_image,
                                                       isrocket: ingredient.is_rocket_delivery,
                                                       link: ingredient.coupang_product_url)
                let convertTag: Tag = Tag(name: ingredient.ingredient_name)
                
                self.mockShopList.append(convert)
                self.mockTagList.append(convertTag)
            }
            
            
            self.likeButton.setTitle("\(item.likes_count)", for: .normal)
            if item.is_liked {
                self.likeButton.setImage(UIImage(named: "heartFill_svg"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart_svg"), for: .normal)
            }
            
            if item.is_saved {
                self.favoriteButton.setImage(UIImage(named: "favoriteFill_svg"), for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(named: "favorite_svg"), for: .normal)
            }
            
            self.commentButton.setTitle("\(item.comments_count)", for: .normal)
            self.favoriteButton.setTitle("\(item.saved_count)", for: .normal)
            self.nickNameLabel.text = item.writtenBy
            self.explanationLabel.text = item.shortform_description
            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
        }).disposed(by: disposeBag)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addView()
//        configureLayout()
//        mockConfigure()
//        configureDataSource()
//        registerCell()
//        collectionView.delegate = self
//        backgroundColor = .blue
//        collectionView.backgroundColor = .clear
////        likeButton.backgroundColor = .red
//        likeButton.rx.tap
//            .subscribe(onNext: { _ in
//                self.likeButton.setImage(UIImage(named:"heartFill_svg"), for: .normal)
//            }).disposed(by: disposeBag)
//        favoriteButton.rx.tap
//            .subscribe(onNext: { _ in
//                self.favoriteButton.setImage(UIImage(named:"favoriteFill_svg"), for: .normal)
//            }).disposed(by: disposeBag)
//
//
//        getItemRelay.subscribe(onNext: { item in
//            print("get Item Relay")
//            self.mockShopList = []
//            self.mockTagList = []
//            self.shortFormInfo = item
//            for ingredient in item.ingredients {
//                let convert: ShopingList = ShopingList(title: ingredient.coupang_product_name,
//                                                       price: ingredient.coupang_product_price,
//                                                       image: ingredient.coupang_product_image,
//                                                       isrocket: ingredient.is_rocket_delivery,
//                                                       link: ingredient.coupang_product_url)
//                let convertTag: Tag = Tag(name: ingredient.ingredient_name)
//
//                self.mockShopList.append(convert)
//                self.mockTagList.append(convertTag)
//            }
//
//
//            self.likeButton.setTitle("\(item.likes_count)", for: .normal)
//            if item.is_liked {
//                self.likeButton.setImage(UIImage(named: "heartFill_svg"), for: .normal)
//            } else {
//                self.likeButton.setImage(UIImage(named: "heart_svg"), for: .normal)
//            }
//
//            if item.is_saved {
//                self.favoriteButton.setImage(UIImage(named: "favoriteFill_svg"), for: .normal)
//            } else {
//                self.favoriteButton.setImage(UIImage(named: "favorite_svg"), for: .normal)
//            }
//
//            self.commentButton.setTitle("\(item.comments_count)", for: .normal)
//            self.favoriteButton.setTitle("\(item.saved_count)", for: .normal)
//            self.nickNameLabel.text = item.writtenBy
//            self.explanationLabel.text = item.shortform_description
//            self.dataSource.apply(self.createSnapshot(), animatingDifferences: true)
//        }).disposed(by: disposeBag)
//    }
    
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
            $0.bottom.equalTo(commentButton.snp.top).offset(-40)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(40)
        }
        
        commentButton.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.top).offset(-40)
            $0.right.width.equalTo(likeButton)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.bottom.equalTo(nickNameLabel.snp.top)
            $0.right.width.equalTo(likeButton)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(explanationLabel.snp.top).offset(-10)
            $0.left.equalToSuperview().inset(20)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.bottom.equalTo(collectionView.snp.top).offset(-10)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalTo(favoriteButton.snp.left).offset(-20)
        }
        
        collectionView.snp.makeConstraints {
//            $0.top.equalTo(explanationLabel.snp.bottom).offset(10)
            $0.height.equalTo(140)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    func registerCell() {
        collectionView.register(ShortFormTagCell1.self, forCellWithReuseIdentifier: ShortFormTagCell1.reuseIdentifier)
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
                heightDimension: .estimated(20)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.1)),
            subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        // Return
        return section
        //        }
        
    }
    
    func createShopingListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 3)
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortFormTagCell1.reuseIdentifier, for: indexPath) as! ShortFormTagCell1
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

extension ShortFormFullScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let item = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.item]
        
        switch item {
        case .ingredient(let ingredient):
            // 재료 섹션의 아이템을 선택한 경우
            // 원하는 동작을 수행하세요.
            break
        case .shopingList(let shopingList):
            print(shopingList)
            // 쇼핑 리스트 섹션의 아이템을 선택한 경우
            // 원하는 동작을 수행하세요.
            // 예: 해당 아이템의 링크로 이동하거나 특정 동작 수행
            openShopingListURL(shopingList.link)
            break
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // 쇼핑 리스트 아이템의 링크를 열기 위한 메서드
    private func openShopingListURL(_ link: String) {
        guard let url = URL(string: link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL: \(url)")
        }
    }
}

extension ShortFormFullScreenView {
    func updateLikeStatus(isLiked: Bool) {
        item.is_liked = isLiked

        if isLiked {
            self.item.likes_count += 1
        } else {
            self.item.likes_count -= 1
        }
        print("좋아요 여부:", item.is_liked)
        print("좋아요 개수:", item.likes_count)
    }

    func updateSaveStatus(isLiked: Bool) {
        self.item.is_liked = isLiked

        if isLiked {
            self.item.saved_count += 1
        } else {
            self.item.saved_count -= 1
        }
        print("저장 여부:", self.item.is_saved)
        print("저장 개수:", self.item.saved_count)
    }

    func didTapLikeButton(completion: @escaping (Bool, String) -> Void) {

        if self.item.is_liked {
            self.item.is_liked = false
            Task {
                if let result: ShortFormLikeSaveResult = await self.unlikeShortForm(item.shortform_id) {
                    self.updateLikeStatus(isLiked: false)
                    completion(result.code == "SUCCESS","cancel")
                }
            }
        } else {
            self.item.is_liked = true
            Task {
                if let result: ShortFormLikeSaveResult = await self.likeShortForm(item.shortform_id) {self.updateLikeStatus(isLiked: true)
                    completion(result.code == "SUCCESS","like")
                }
            }
        }
    }

    func didTapSaveButton(completion: @escaping (Bool, String) -> Void) {
        print("현재 저장상태:", item.is_saved)
        if item.is_saved {
            self.item.is_saved = false
            Task {
                if let result: ShortFormLikeSaveResult = await self.unsaveShortForm(item.shortform_id) {
                    
                    if !(result.code == "4005") {
                        self.updateSaveStatus(isLiked: true)
                        completion(result.code == "SUCCESS","cancel")
                    } else {
                        completion(false, "cancel")
                    }
                }
            }
        } else {
            self.item.is_saved = true
            Task {
                if let result: ShortFormLikeSaveResult = await self.saveShortForm(item.shortform_id) {
                    if !(result.code == "4005") {
                        self.updateSaveStatus(isLiked: true)
                        completion(result.code == "SUCCESS","like")
                    } else {
                        completion(false, "like")
                    }
                }
            }
        }
    }
}

extension ShortFormFullScreenView {
    func saveShortForm(_ shortFormId: Int) async -> ShortFormLikeSaveResult? {
        do {
            let data1: ShortFormLikeSaveResult = try await NetworkManager.shared.get(.saveShortForm("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func unsaveShortForm(_ shortFormId: Int) async -> ShortFormLikeSaveResult?{
        do {
            let data1: ShortFormLikeSaveResult = try await NetworkManager.shared.get(.unsaveShortForm("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func likeShortForm(_ shortFormId: Int) async -> ShortFormLikeSaveResult? {
        do {
            let data1: ShortFormLikeSaveResult = try await NetworkManager.shared.get(.likeShortForm("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func unlikeShortForm(_ shortFormId: Int) async -> ShortFormLikeSaveResult? {
        do {
            let data1: ShortFormLikeSaveResult = try await NetworkManager.shared.get(.unlikeShortForm("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
}

#if DEBUG
import SwiftUI
struct ForShortFormFullScreenView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        ShortFormFullScreenView(item: ShortFormInfo(comments_count: 3, created_date: "", ingredients: [ShortFormDetailIngredient(ingredient_id: 3, ingredient_name: "당근", ingredient_type: "", ingredient_size: nil, ingredient_unit: "유닛", coupang_product_image: "", coupang_product_name: "이름", coupang_product_price: 32000, coupang_product_url: "", is_rocket_delivery: true)], is_liked: true, is_saved: true, likes_count: 3, saved_count: 3, shortform_description: "설명", shortform_id: 3, shortform_name: "dlfma", video_time: "시간", video_url: "", writtenBy: "뿡뿡이", writtenid: 3))
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForShortFormFullScreenView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            // SE 미리보기
            UIViewControllerPreview {
                UINavigationController(rootViewController: ShortFormViewController())
            }
            .ignoresSafeArea()
            .previewDevice("iPhone SE (2nd generation)")
            .previewDisplayName("iPhone SE")
            
            // 14 Pro 미리보기
            UIViewControllerPreview {
                UINavigationController(rootViewController: ShortFormViewController())
            }
            .ignoresSafeArea()
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("iPhone 14 Pro")
        }
    }
}
#endif
