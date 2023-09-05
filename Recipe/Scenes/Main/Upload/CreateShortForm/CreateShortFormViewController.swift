//
//  CreateShortFormViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AVFoundation


final class CreateShortFormViewController: BaseViewController {
    
    
    private let createShortFormView = CreateShortFormView()
    private var disposeBag = DisposeBag()
    var didSendEventClosure: ((CreateShortFormViewController.Event) -> Void)?
    var activeTextField: UITextField?
    let videoPickerManager = VideoPickerManager()
    private let viewModel = CreateShortFormViewModel()
    enum Event {
        case registerButtonTapped
        ///Todo: createShortFormButtonTapped 로직 연결하기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        bind()
        createShortFormView.delegate = self
        configureNavigationBar()
        viewModel.allValuesReceived.subscribe(onNext: { _ in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }).disposed(by: disposeBag)
        createShortFormView.viewModel = viewModel
    }
    
    @objc func completeButtonTapped() {
        print(#function)
        let list = viewModel.currentIngredientList
        guard let videoURL = viewModel.currentVideoURL,
              videoURL.isFileURL,
              let title = viewModel.currentTitle,
              !title.isEmpty,
              let description = viewModel.currentDescription,
              !description.isEmpty else {
            return
        }
        do {
            Task {
                DispatchQueue.main.async {
                    LoadingIndicator.showLoading()
                }
                let data2: UploadResult? = await self.viewModel.addVideo(videoURL: videoURL)
                if let data2, data2.code == "SUCCESS" {
                    let videoURL = data2.data
                    let parameter = ["description": description,
                                     "ingredients_ids": list,
                                     "shortform_name": title,
                                     "video_time":"",
                                     "video_url": videoURL
                    ]
                    do {
                        let data3: ShortFormResult = try await NetworkManager.shared.get(.createShortForm, parameters: parameter)
                        
                        if data3.code == "SUCCESS" {
                            DispatchQueue.main.async {
                                LoadingIndicator.hideLoading()
                            }
                            didSendEventClosure?(.registerButtonTapped)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            LoadingIndicator.hideLoading()
                        }
                        print("error")
                    }
                }
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        createShortFormView.viewModel = viewModel
//    }
    
    
}
//MARK: - Method(Normal)
extension CreateShortFormViewController {
    private func addView() {
        view.addSubViews(createShortFormView)
    }
    
    private func configureLayout() {
        createShortFormView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
        let completeButton = UIButton(type: .system)
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.grayScale6, for: .normal)
        completeButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: completeButton)
        navigationItem.rightBarButtonItem = barButtonItem
        defaultNavigationBackButton(backButtonColor: .grayScale5 ?? .gray)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func getThumbnailImage(for url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("썸네일 받아오기 실패: \(error)")
            return nil
        }
    }
}
//MARK: - Method(Rx bind)
extension CreateShortFormViewController {
    func bind() {
        
    }
}

extension CreateShortFormViewController: CreateShortFormViewDelegate {
    func addVideoButtonTapped() {
        videoPickerManager.presentVideoPicker(in: self) { [weak self] videoURL in
            guard let self = self, let videoURL = videoURL else { return }
            if let videoThumbnail = self.getThumbnailImage(for: videoURL) {
                /// 이미지 넘겨버리기
                self.viewModel.videoThumbnailImage.accept(videoThumbnail)
                self.viewModel.videoURLRelay.accept(videoURL)
            }
        }
    }
    
    func modifyVideoButtonTapped() {
        videoPickerManager.presentVideoPicker(in: self) { [weak self] videoURL in
            guard let self = self, let videoURL = videoURL else { return }
            if let videoThumbnail = self.getThumbnailImage(for: videoURL) {
                /// 이미지 넘겨버리기
                self.viewModel.videoThumbnailImage.accept(videoThumbnail)
                self.viewModel.videoURLRelay.accept(videoURL)
            }
        }
    }
    
    func addIngredientCellTapped(_ item: IngredientInfo) {
        print(#function)
        print(item.ingredient_id)
        let vc = AddIngredientViewController(item: item)
        vc.didSendEventClosure = { [weak self] cases in
            switch cases {
            case .okButtonTapped:
                self?.createShortFormView.addIngredientMockData.append(vc.forTag)
                self?.viewModel.appendString(vc.forTag, vc.ingredient.ingredient_id)
                self?.createShortFormView.dataSource.apply((self?.createShortFormView.createSnapshot())!, animatingDifferences: true)
            default:
                return
            }
        }
        vc.item = item
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: false)
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct CreateShortFormViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CreateShortFormViewController())
            .toPreview()
    }
}
