//
//  ShortFormViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import UPCarouselFlowLayout

final class ShortFormViewController: BaseViewController {
    
    ///UI Properties
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.textPadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
    
    var didSendEventClosure: ((ShortFormViewController.Event) -> Void)?
    var disposeBag = DisposeBag()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: aa())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(collectionView, searchTextField, searchImageButton)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShortFormCell.self, forCellWithReuseIdentifier: ShortFormCell.reuseIdentifier)
        configureLayout()
        configureNavigationTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    enum Event {
        case go
    }
}

//MARK: - Method(Normal)
extension ShortFormViewController {
    
    func configureLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.right.equalToSuperview().inset(13)
            $0.height.equalTo(51.57)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.right.equalTo(searchTextField).inset(15)
            $0.centerY.equalTo(searchTextField)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func configureNavigationTabBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(imageName: "bell.hasAlert")
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButtonWithLabel(imageName: "logo", size: CGSize(width: 100, height: 50))
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func aa() -> UICollectionViewFlowLayout {
        let layout = UPCarouselFlowLayout()
        layout.sideItemScale = 0.7
        layout.spacingMode = .fixed(spacing: 15)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(view.frame.width * 0.8, view.frame.height * 0.6)
        return layout
    }
}

//MARK: - CollectionView Delegate
extension ShortFormViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortFormCell.reuseIdentifier, for: indexPath) as! ShortFormCell
         return cell
    }
}

//MARK: - VC Preview
import SwiftUI
struct ShortFormViewController_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: ShortFormViewController())
            .toPreview()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
