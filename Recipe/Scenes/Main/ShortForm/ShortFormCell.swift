//
//  Cell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit
import AVFoundation
import RxSwift
import RxCocoa
import AVKit

protocol ShortFormCellDelegate: AnyObject {
    func didTapVideo(index: Int?, player: AVPlayer, playerLayer: AVPlayerLayer)
    func didTapLikeButton(item: ShortFormInfo, index: Int, completion: @escaping (Bool, String) -> Void)
    func didTapSaveButton(item: ShortFormInfo, index: Int, completion: @escaping (Bool, String) -> Void)
}

class ShortFormCell: UICollectionViewCell {
    
    private let shortFormbackground: UIView = {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    
    var videoURL: String?
    var statusObserver: NSKeyValueObservation?
    var playerStatusObserver: NSKeyValueObservation?
    lazy var player: AVPlayer = AVPlayer(playerItem: nil)

    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resize
        return playerLayer
    }()
    
    private let playtimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .systemFont(ofSize: 14)
        return v
    }()
    
    let likeButton: ExtendedTouchAreaButton = {
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
        v.setTitle("0", for: .normal)
        v.alignTextBelow(spacing: 10)
        v.titleLabel?.textAlignment = .center
        return v
    }()
    
    let favoriteButton: ExtendedTouchAreaButton = {
        let v = ExtendedTouchAreaButton()
        v.setImage(UIImage(named: "favorite_svg"), for: .normal)
        v.setTitle("21", for: .normal)
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
    
    let watchImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "noon")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    weak var delegate: ShortFormCellDelegate?
    var index: Int?
    var shortFormInfo: ShortFormInfo?
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        mockConfigure()
        self.shortFormbackground.layer.addSublayer(self.playerLayer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        contentView.addGestureRecognizer(tapGesture)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("shortformCell tapped")
                guard let self = self, let idx = self.index, let item = self.shortFormInfo else { return }
                
                self.delegate?.didTapLikeButton(item: item, index: idx) { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.updateLikeUI(for: action)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("TAPPED")
                guard let self = self, let idx = self.index, let item = self.shortFormInfo else { return }
                
                self.delegate?.didTapSaveButton(item: item, index: idx) { isSuccess, action in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.updateSaveUI(for: action)
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        print(#function)
        // AVPlayerViewController를 모달로 표시합니다.
        delegate?.didTapVideo(index: index, player: player, playerLayer: playerLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
        playerLayer.frame = shortFormbackground.layer.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        self.stop()
        self.statusObserver?.invalidate()
        self.playerStatusObserver?.invalidate()
        disposeBag = DisposeBag()
//        likeButton.setImage(UIImage(named: "heart_svg"), for: .normal)
//        likeButton.setTitle("0", for: .normal)
//        favoriteButton.setImage(UIImage(named: "favorite_svg"), for: .normal)
//        favoriteButton.setTitle("0", for: .normal)
    }
}

//MARK: - Method(Normal)
extension ShortFormCell {
    func addView() {
//        addSubViews(shortFormbackground, watchImageView, playtimeLabel, likeButton, commentButton, favoriteButton, nickNameLabel, explanationLabel)
        contentView.addSubview(loadingIndicator)
        contentView.addSubViews(shortFormbackground, watchImageView, playtimeLabel, likeButton, commentButton, favoriteButton, nickNameLabel, explanationLabel)
    }
    func configureLayout() {
        
        shortFormbackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
//            $0.edges.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }
        
        playtimeLabel.snp.makeConstraints {
            $0.top.right.equalTo(shortFormbackground).inset(30)
            $0.width.equalTo(40)
            $0.height.equalTo(14)
        }

        likeButton.snp.makeConstraints {
            $0.bottom.equalTo(commentButton.snp.top).offset(-40)
            $0.right.equalTo(shortFormbackground).inset(40)
            $0.width.equalTo(30)
            $0.height.equalTo(35)
        }

        commentButton.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.top).offset(-40)
            $0.right.width.equalTo(likeButton)
            $0.height.equalTo(35)
        }

        favoriteButton.snp.makeConstraints {
            $0.bottom.equalTo(nickNameLabel.snp.top)
            $0.right.width.equalTo(likeButton)
            $0.height.equalTo(35)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(explanationLabel.snp.top).offset(-10)
            $0.left.equalTo(shortFormbackground).inset(20)
        }
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(shortFormbackground.snp.bottom).inset(30)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalTo(favoriteButton.snp.left).offset(-20)
        }
        
        watchImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(47.24)
            $0.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(shortFormbackground)
        }
    }
    func mockConfigure() {
        playtimeLabel.text = "00:49"
        nickNameLabel.text = "happyday125"
        explanationLabel.text = "탕후루를 집에서 손쉽게 만드는 법을 공개합니다"
    }
    
    func configure(_ url: String, item: ShortFormInfo, index: Int?) {
        print(#function)
        guard self.videoURL != url else { return } // 동일한 URL이 아닐 때만 playVideo 호출
        self.videoURL = url
        self.index = index
        self.shortFormInfo = item
        playVideo(url: url)
        
        DispatchQueue.main.async {
            print("====================")
            print("likeCount:",item.likes_count)
            print("saveCount:",item.saved_count)
            print("commentsCount:",item.comments_count)
            print("====================")
            self.nickNameLabel.text = item.writtenBy
            self.playtimeLabel.text = item.video_time
            self.explanationLabel.text = item.shortform_description
            self.likeButton.setTitle("\(item.likes_count)", for: .normal)
            self.commentButton.setTitle("\(item.comments_count)", for: .normal)
            self.favoriteButton.setTitle("\(item.saved_count)", for: .normal)
            
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
        }
    }
    
    func updateLikeUI(for action: String) {
        // 1. Set the correct image
        let imageName = (action == "cancel") ? "heart_svg" : "heartFill_svg"
        likeButton.setImage(UIImage(named: imageName), for: .normal)

        // 2. Adjust the count
        if let txt = likeButton.titleLabel?.text, let count = Int(txt) {
            let updatedCount = (action == "cancel") ? count - 1 : count + 1
            likeButton.setTitle("\(updatedCount)", for: .normal)
        }
    }
    
    func updateSaveUI(for action: String) {
        // 1. Set the correct image
        let imageName = (action == "cancel") ? "favorite_svg" : "favoriteFill_svg"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)

        // 2. Adjust the count
        if let txt = favoriteButton.titleLabel?.text, let count = Int(txt) {
            let updatedCount = (action == "cancel") ? count - 1 : count + 1
            favoriteButton.setTitle("\(updatedCount)", for: .normal)
        }
    }
    
    func playerStatusDescription(_ status: AVPlayer.Status) -> String {
        switch status {
        case .unknown:
            return "Unknown"
        case .readyToPlay:
            return "ReadyToPlay"
        case .failed:
            return "Failed: \(String(describing: player.error))"
        default:
            return "Other"
        }
    }
    
    func playVideo(url: String) {
        print(#function)
        guard let validURL = URL(string: url) else {
            print("Invalid URL")
            return
        }

        self.statusObserver?.invalidate()
        self.playerStatusObserver?.invalidate()
        let playerItem = AVPlayerItem(url: validURL)

        statusObserver = playerItem.observe(\.status, options: [.new], changeHandler: { [weak self] (item, change) in
            guard let self = self else { return }
            if item.status == .readyToPlay {
                print("ReadyToPlay")
                self.loadingIndicator.stopAnimating()
                self.player.play()
            } else if item.status == .failed {
                print("Failed: \(String(describing: item.error))")
                self.loadingIndicator.stopAnimating()
            } else {
                print("Unknown Error")
                self.loadingIndicator.startAnimating()
            }
            
            if item.isPlaybackBufferEmpty {
                print("Buffer is empty")
                self.loadingIndicator.startAnimating()
            }

            if item.isPlaybackLikelyToKeepUp {
                print("Playback is likely to keep up")
            }

            if item.isPlaybackBufferFull {
                print("Buffer is full")
            }
            
            if let timeRange = item.loadedTimeRanges.first?.timeRangeValue {
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
                print("Loaded time range: \(startSeconds) - \(startSeconds + durationSeconds)")
            }
            
            if let error = item.error {
                print("Error occurred: \(error.localizedDescription)")
            }
        })

        // AVPlayer의 상태 감시 추가
        playerStatusObserver = player.observe(\.status, options: [.new], changeHandler: { [weak self] (player, change) in
            print("Player status: \(self?.playerStatusDescription(player.status) ?? "Unknown")")
            
//            if player.isVideoOutputDisabled {
//                print("Video output is disabled")
//            }
            
            switch player.timeControlStatus {
            case .paused:
                print("Player is paused")
            case .playing:
                print("Player is playing")
            case .waitingToPlayAtSpecifiedRate:
                print("Player is waiting to play at specified rate")
            default:
                break
            }
            
        })

        player.replaceCurrentItem(with: playerItem)
        player.volume = 0
    }
    
    func stop() {
        player.replaceCurrentItem(with: nil)
    }
}

////MARK: - VC Preview
//import SwiftUI
//struct ShortFormViewController1_preview: PreviewProvider {
//    static var previews: some View {
//        
//        UINavigationController(rootViewController: ShortFormViewController())
//            .toPreview()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//    }
//}

#if DEBUG
import SwiftUI
struct ForShortFormCell: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        ShortFormCell()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForShortFormCell_Preview: PreviewProvider {
    static var previews: some View {
        ForShortFormCell()
            .previewLayout(.fixed(width: 250, height: 500))
    }
}
#endif
