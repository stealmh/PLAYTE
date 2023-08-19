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
    enum Event {
        case registerButtonTapped
        ///Todo: createShortFormButtonTapped 로직 연결하기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        bind()
        setNavigationTitle("나의 레시피 작성")
        createShortFormView.delegate = self
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
            print(videoURL)
            if let videoThumbnail = getThumbnailImage(for: videoURL) {
                /// 이미지 넘겨버리기
                createShortFormView.videoThumbnailImage.accept(videoThumbnail)
            }
        }
    }
    
    func modifyVideoButtonTapped() {
        
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
