//
//  CreateReviewView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol CreateReviewViewDelegate: AnyObject {
    func didTapRegisterButton()
}

class CreateReviewView: UIView {
    
    enum Section: Hashable {
        case photo
    }
    
    enum Item: Hashable {
        case photo(Photo)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        v.showsVerticalScrollIndicator = false
        return v
    }()
    
    private let recipeImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.image = UIImage(named: "popcat")
        return v
    }()
    
    lazy var ratingStarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var ratingSlider: TapUISlider = {
        let slider = TapUISlider()
        slider.maximumValue = 5 // 최대값
        slider.minimumValue = 0 // 최소값
        // 실제로 slider는 사용자 눈에 보이지 않을 것이므로 모든 컬러는 clear로 설정
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.addTarget(self, action: #selector(tapSlider(_:)), for: .valueChanged)
        return slider
    }()
    
    private let ratingLabel: UILabel = {
        let v = UILabel()
        v.textColor = .mainColor
        v.font = .systemFont(ofSize: 16)
        v.text = "레시피는 어떠셨나요?"
        return v
    }()
    
    private let textfieldTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.text = "솔직한 후기를 남겨주세요."
        return v
    }()
    
    ///UI Properties
    private let textView: UITextView = {
        let v = UITextView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .gray.withAlphaComponent(0.2)
        v.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return v
    }()
    
    private let placeholderLabel: UILabel = {
        let v = UILabel()
        v.text = "최소 10자 이상 입력해주세요."
        v.textColor = .gray
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    private let textCountLabel: UILabel = {
        let v = UILabel()
        v.text = "0/1000"
        v.textColor = .gray
        return v
    }()
    
    private let photoTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.text = "사진 후기 0"
        v.textColor = .mainColor
        v.asColor(targetString: "사진 후기", color: .black)
        return v
    }()
    
    private let photoTitle2: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.text = "/5"
        v.textColor = .gray
        return v
    }()
    
    let registerButton: UIButton = {
        let v = UIButton()
        v.setTitle("등록", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 5
        v.backgroundColor = .mainColor
        return v
    }()
    
    /// Properties
    private var starImageViews: [UIImageView] = []
    private var dataSource: Datasource!
    private let disposeBag = DisposeBag()
    weak var delegate: CreateReviewViewDelegate?
    private var mockData: [Photo] = [
        Photo(image: UIImage(systemName: "photo")!),
        Photo(image: UIImage(named: "popcat")!),
        Photo(image: UIImage(named: "StarFill")!),
        Photo(image: UIImage(named: "StarEmpty")!),
        Photo(image: UIImage(named: "like")!)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        configureLayout()
        setRatingImageView()
        bind()
        configureDataSource()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapSlider(_ sender: UISlider) {
        print(#function)
        // 슬라이더의 값을 올림 하여 받아옴 (사이에서 멈출 때는 더 큰 수에 반응)
        var intValue = Int(ceil(sender.value))
        ratingLabel.text = intValue < 1 ? "레시피는 어떠셨나요?" : "\(intValue).0"
        for index in 0..<5 {
            if intValue == 1 {
                intValue -= 1 // index에 맞추기 위해 -1
                starImageViews[index].image = UIImage(named: "StarFill")
            } else if index < intValue { // intValue 보다 작은 건 칠하기
                starImageViews[index].image = UIImage(named: "StarFill")
            } else { // intValue 보다 크면 빈 별 처리
                starImageViews[index].image = UIImage(named: "StarEmpty")
            }
        }
    }
}

extension CreateReviewView {
    func addView() {
        addSubViews(recipeImageView, ratingStarStackView, ratingSlider, ratingLabel, textView, placeholderLabel, textCountLabel,textfieldTitle, photoTitle, photoTitle2, collectionView, registerButton)
        
    }
    func configureLayout() {
        recipeImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        ratingSlider.snp.makeConstraints {
            $0.top.equalTo(recipeImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        ratingStarStackView.snp.makeConstraints {
            $0.edges.equalTo(ratingSlider)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(ratingStarStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        textfieldTitle.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(textfieldTitle.snp.bottom).offset(10)
            $0.left.right.equalTo(textfieldTitle)
            $0.height.equalTo(200)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).inset(10)
            $0.left.equalTo(textView).inset(23)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.right.bottom.equalTo(textView).inset(20)
        }
        
        photoTitle.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.left.equalTo(textfieldTitle)
        }
        
        photoTitle2.snp.makeConstraints {
            $0.top.equalTo(photoTitle)
            $0.left.equalTo(photoTitle.snp.right)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(photoTitle.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        registerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(collectionView.snp.bottom).offset(60)
            $0.height.equalTo(50)
        }
    }
    
    func setRatingImageView() {
        for index in 0..<5 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "StarEmpty")
            imageView.tag = index
            ratingStarStackView.addArrangedSubview(imageView)
            starImageViews.append(ratingStarStackView.subviews[index] as? UIImageView ?? UIImageView())
        }
    }
    
    func registerCell() {
        collectionView.register(PhotoReviewCell.self, forCellWithReuseIdentifier: PhotoReviewCell.reuseIdentifier)
    }
}

//MARK: - Method(Comp + Diff)
extension CreateReviewView {
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    
    private func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return createHeaderSection()
    }
    
    private func createHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1)), subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.contentInsets = NSDirectionalEdgeInsets(top: -100, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func configureDataSource() {
        dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)}
        dataSource.apply(createSnapshot(), animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell{
        switch item {
        case .photo(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.reuseIdentifier, for: indexPath) as! PhotoReviewCell
            cell.configure(data)
            cell.delegate = self
            return cell
        }
        
    }
    
    private func createSnapshot() -> Snapshot{
        var snapshot = Snapshot()
        snapshot.appendSections([.photo])
        snapshot.appendItems(mockData.map({ Item.photo($0) }), toSection: .photo)
        return snapshot
    }
    
    private func deleteSnapshot(_ item: Item) -> Snapshot{
        var snapshot = Snapshot()
        snapshot.deleteItems([item])
        snapshot.deleteItems(mockData.map { CreateReviewView.Item.photo($0) })
        return snapshot
    }
}

extension CreateReviewView {
    func bind() {
        textView.rx.text.orEmpty
            .scan("") { previous, new in   (new.count > 1000) ? previous : new  }
            .subscribe(onNext: { data in
                self.placeholderLabel.isHidden = data.isEmpty ? false : true
                self.textCountLabel.text = "\(data.count)/1000"
                self.textView.text = data
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe(onNext: { _ in
                /// Todo: 등록하고 뒤로가기 추가
                self.delegate?.didTapRegisterButton()
            }).disposed(by: disposeBag)
    }
}

extension CreateReviewView: PhotoReviewCellDelegate {
    func deleteTapped(cell: PhotoReviewCell) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            if indexPath.row != 0 {
                mockData.remove(at: indexPath.row)
                photoTitle.text = "사진 후기 \(mockData.count - 1)"
                photoTitle.asColor(targetString: "사진 후기", color: .black)
                dataSource.apply(createSnapshot(), animatingDifferences: true)
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct ForCreateReviewView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        CreateReviewView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForCreateReviewView_Preview: PreviewProvider {
    static var previews: some View {
        ForCreateReviewView()
        //            .previewLayout(.fixed(width: 327, height: 241))
            .ignoresSafeArea()
    }
}
#endif

class TapUISlider: UISlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let width = self.frame.size.width
        let tapPoint = touch.location(in: self)
        let fPercent = tapPoint.x/width
        let nNewValue = self.maximumValue * Float(fPercent)
        if nNewValue != self.value {
            self.value = nNewValue
        }
        return true
    }
}

