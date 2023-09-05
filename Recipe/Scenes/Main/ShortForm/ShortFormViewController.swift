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
import AVFoundation

final class ShortFormViewController: BaseViewController {
    
    ///UI Properties
    private let searchTextField: PaddingUITextField = {
        let v = PaddingUITextField()
        v.textPadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "F8F8F8")
        v.placeholder = "레시피 및 재료를 검색해보세요."
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isEnabled = false
        return v
    }()
    
    private let searchImageButton: UIButton = {
        let v = UIButton()
        let img = v.buttonImageSize(imageName: "search_svg", size: 24)
        v.setImage(img, for: .normal)
        v.contentMode = .scaleAspectFit
        v.tintColor = .mainColor
        return v
    }()
    
    var didSendEventClosure: ((ShortFormViewController.Event) -> Void)?
    var disposeBag = DisposeBag()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: aa())
    private var video: [ShortFormInfo] = []
    
    var viewModel = ShortFormViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(collectionView, searchTextField, searchImageButton)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShortFormCell.self, forCellWithReuseIdentifier: ShortFormCell.reuseIdentifier)
        configureLayout()
        configureNavigationTabBar()
        collectionView.reloadData()
        
        
        searchImageButton.rx.tap
            .subscribe(onNext: { _ in
                let vc = ShortFormSearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }).disposed(by: disposeBag)
        
        viewModel.shortForm
            .observe(on: MainScheduler.instance) // 옵저버블의 처리를 메인 스레드에서 수행
            .flatMap { shortForm -> Observable<[ShortFormInfo]> in
                return Observable.create { observer in
                    DispatchQueue.main.async { // 메인 스레드에서 작업
                        var videoList: [ShortFormInfo] = []
                        for i in shortForm.data.content {
                            if UserReportHelper.shared.isUserIdInUserReports(userId: Int64(i.writtenid)) {
                                print("차단자가 있음")
                            } else {
                                videoList.append(i)
                            }
                        }
                        observer.onNext(videoList)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { videoList in
                print("== shortForm subscribe ==")
                self.video = videoList
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        //        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will Appear")
        Task {
            await viewModel.getShortFormList()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    enum Event {
        case go
    }
    @objc func moreButtonTapped(sender: UIBarButtonItem) {
        self.showToastSuccess(message: "준비중입니다 기대해주세요 :)")
    }
}

//MARK: - Method(Normal)
extension ShortFormViewController {
    
    func configureLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(51.57)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.right.equalTo(searchTextField).inset(15)
            $0.centerY.equalTo(searchTextField)
        }
        //        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.4)
            //            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func configureNavigationTabBar() {
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(imageName: "bell.default_svg", size: CGSize(width: 50, height: 40))
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(moreButtonTapped), imageName: "bell.default_svg", size: CGSize(width: 50, height: 40))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(imageName: "shorts", size: CGSize(width: 85.36, height: 28.52))
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func aa() -> UICollectionViewFlowLayout {
        let layout = UPCarouselFlowLayout()
        layout.sideItemScale = 0.7
        layout.spacingMode = .fixed(spacing: 15)
        //        layout.spacingMode = .fixed(spacing: 50)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(view.frame.width * 0.8, view.frame.height * 0.65)
        return layout
    }
    
}

//MARK: - CollectionView Delegate
extension ShortFormViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return video.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortFormCell.reuseIdentifier, for: indexPath) as! ShortFormCell
        let item = video[indexPath.row]
        let index = indexPath.row
        cell.configure(video[indexPath.row].video_url, item: video[indexPath.row], index: indexPath.row)
        cell.delegate = self
        
        cell.commentButton.rx.tap
            .subscribe(onNext: { _ in
                print("commentButton Tapped")
                Task {
                    do {
                        let a: RecipeComment = try await NetworkManager.shared.get(.shortformComment("\(self.video[indexPath.row].shortform_id)"))
                        let vc = CommentViewController(comment: a, divideId: self.video[indexPath.row].shortform_id)
                        self.navigationController?.present(vc, animated: true)
                        
                        
                    } catch {
                        print("error")
                    }
                }
            }).disposed(by: cell.disposeBag)
        
        cell.favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapSaveButton(item: item, index: index) { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            let imageName = (action == "cancel") ? "favorite_svg" : "favoriteFill_svg"
                            cell.favoriteButton.setImage(UIImage(named: imageName), for: .normal)
                            
                            // 2. Adjust the count
                            if let txt = cell.favoriteButton.titleLabel?.text, let count = Int(txt) {
                                let updatedCount = (action == "cancel") ? count - 1 : count + 1
                                cell.favoriteButton.setTitle("\(updatedCount)", for: .normal)
                            }
                        }
                    }
                }
            }).disposed(by: cell.disposeBag)
        
        cell.likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("shortformCell tapped")
                
                self?.didTapLikeButton(item: item, index: index) { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            let imageName = (action == "cancel") ? "heart_svg" : "heartFill_svg"
                            cell.likeButton.setImage(UIImage(named: imageName), for: .normal)
                            
                            // 2. Adjust the count
                            if let txt = cell.likeButton.titleLabel?.text, let count = Int(txt) {
                                let updatedCount = (action == "cancel") ? count - 1 : count + 1
                                cell.likeButton.setTitle("\(updatedCount)", for: .normal)
                            }
                        }
                    }
                }
            }).disposed(by: cell.disposeBag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ShortFormCell {
            cell.playVideo(url: video[indexPath.row].video_url)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ShortFormCell {
            cell.stop()
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let vc = UIViewController()
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
}

extension ShortFormViewController: ShortFormCellDelegate {
    
    func updateLikeStatus(for index: Int, isLiked: Bool) {
        self.video[index].is_liked = isLiked
        
        if isLiked {
            self.video[index].likes_count += 1
        } else {
            self.video[index].likes_count -= 1
        }
        print("좋아요 여부:", self.video[index].is_liked)
        print("좋아요 개수:", self.video[index].likes_count)
    }
    
    func updateSaveStatus(for index: Int, isLiked: Bool) {
        self.video[index].is_liked = isLiked
        
        if isLiked {
            self.video[index].saved_count += 1
        } else {
            self.video[index].saved_count -= 1
        }
        print("저장 여부:", self.video[index].is_saved)
        print("저장 개수:", self.video[index].saved_count)
    }
    
    func didTapLikeButton(item: ShortFormInfo, index: Int, completion: @escaping (Bool, String) -> Void) {
        
        let currentItem = video[index]
        if currentItem.is_liked {
            self.video[index].is_liked = false
            Task {
                if let result: ShortFormDefaultResult = await self.viewModel.unlikeShortForm(item.shortform_id) {
                    self.updateLikeStatus(for: index, isLiked: false)
                    completion(result.code == "SUCCESS","cancel")
                }
            }
        } else {
            self.video[index].is_liked = true
            Task {
                if let result: ShortFormDefaultResult = await self.viewModel.likeShortForm(item.shortform_id) {self.updateLikeStatus(for: index, isLiked: true)
                    completion(result.code == "SUCCESS","like")
                }
            }
        }
    }
    
    func didTapSaveButton(item: ShortFormInfo, index: Int, completion: @escaping (Bool, String) -> Void) {
        let currentItem = video[index]
        print("현재 저장상태:", currentItem.is_saved)
        if currentItem.is_saved {
            self.video[index].is_saved = false
            Task {
                if let result: ShortFormDefaultResult = await self.viewModel.unsaveShortForm(item.shortform_id) {
                    self.updateSaveStatus(for: index, isLiked: false)
                    completion(result.code == "SUCCESS","cancel")
                }
            }
        } else {
            self.video[index].is_saved = true
            Task {
                if let result: ShortFormDefaultResult = await self.viewModel.saveShortForm(item.shortform_id) {self.updateSaveStatus(for: index, isLiked: true)
                    completion(result.code == "SUCCESS","like")
                }
            }
        }
    }
    
    
    func didTapVideo(index: Int?, player: AVPlayer, playerLayer: AVPlayerLayer) {
        print(#function)
        guard let index = index else { return }
        let data = video[index]
        let vc = ShortFormFullScreenViewController(item: data, player: player, playerLayer: playerLayer)
        ShortFormCoreDataHelper.shared.saveShortForm(code: data)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - VC Preview
import SwiftUI
import AVKit
struct ShortFormViewController_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: ShortFormViewController())
            .toPreview()
            .ignoresSafeArea()
    }
}
