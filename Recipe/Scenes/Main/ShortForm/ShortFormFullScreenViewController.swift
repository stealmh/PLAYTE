//
//  ShortFormFullScreenViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit
import AVFoundation

class ShortFormFullScreenViewController: BaseViewController {
    var videoURL: URL?
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    
    private let background = ShortFormFullScreenView()
    private var slider: UISlider = {
        let v = UISlider()
        v.thumbTintColor = .mainColor
        v.minimumTrackTintColor = .mainColor
        v.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        return v
    }()
    
    private let pausePlayButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "pause"), for: .normal)
        v.isEnabled = false
        return v
    }()
    
    private let currentPlayTimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .systemFont(ofSize: 14)
        v.text = "00:00"
        v.contentMode = .center
        return v
    }()
    
    private let totalPlayTimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white.withAlphaComponent(0.7)
        v.font = .systemFont(ofSize: 14)
        v.text = "00:00"
        v.contentMode = .center
        return v
    }()
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        stackView.addArrangeViews(pausePlayButton, currentPlayTimeLabel, totalPlayTimeLabel)
        view.addSubview(background)
        view.addSubview(slider)
        view.addSubview(stackView)
        configureLayout()
        defaultNavigationBackButton(backButtonColor: .white)
        setupUI()
    }
    
    init(videoURL: URL?, player: AVPlayer, playerLayer: AVPlayerLayer) {
        // 초기화 코드 추가
        self.videoURL = videoURL
        self.player = player
        self.playerLayer = playerLayer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    deinit {
        // Notification 관련 등록 해제
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: Method(Normal)
extension ShortFormFullScreenViewController {
    func configureLayout() {
        background.backgroundColor = .clear
        
        background.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().inset(40)
        }
        
        slider.snp.makeConstraints {
            $0.top.equalTo(background.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(slider)
        }
        
        pausePlayButton.snp.makeConstraints {
            $0.top.left.height.equalTo(stackView)
            $0.width.equalTo(20)
        }
        
        currentPlayTimeLabel.snp.makeConstraints {
            $0.top.height.equalTo(stackView)
            $0.left.equalTo(pausePlayButton.snp.right).offset(10)
            $0.width.equalTo(stackView).dividedBy(3)
        }
        
        totalPlayTimeLabel.snp.makeConstraints {
            $0.top.height.equalTo(stackView)
            $0.left.equalTo(currentPlayTimeLabel.snp.right)
            $0.right.equalTo(stackView)
        }
    }
}
//MARK: Method(Player)
extension ShortFormFullScreenViewController {
    func setupPlayer() {
        guard let videoURL else { return }
        player = AVPlayer(url: videoURL)
        player.volume = 0
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        
        // 재생 위치 변경을 감지하는 옵저버를 추가합니다.
        let timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] time in
            guard let player = self?.player else { return }
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 0, timescale: 1))
            let currentTime = CMTimeGetSeconds(time)
            self?.slider.value = Float(currentTime / duration)
            
            // 현재 시청한 시간
            let currentSeconds = Int(currentTime)
            // 남은 전체 시간
            let remainingSeconds = Int(duration)
            print(self?.timeString(from: currentSeconds))
            print("-" + (self?.timeString(from: remainingSeconds) ?? ""))
            self?.currentPlayTimeLabel.text = self?.timeString(from: currentSeconds)
            self?.totalPlayTimeLabel.text = " / " + (self?.timeString(from: remainingSeconds) ?? "")
        }
        
        // 비디오가 끝났을 때 재생 시점을 처음으로 돌려주는 옵저버를 추가합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupUI() {
        // 재생바를 추가합니다.
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

private extension ShortFormFullScreenViewController {
    @objc func sliderValueChanged(_ sender: UISlider) {
        print(#function)
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 0, timescale: 1))
        let targetTime = duration * Double(sender.value)
        let time = CMTime(seconds: targetTime, preferredTimescale: 1)
        player.seek(to: time)
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if player.rate == 1.0 { // 현재 재생 중인 상태
            player.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else { // 일시정지 상태
            player.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
}

//MARK: - VC Preview
import SwiftUI
import AVKit
struct ShortFormViewController1_preview: PreviewProvider {
    static var previews: some View {
        
        UINavigationController(rootViewController: ShortFormViewController())
            .toPreview()
            .ignoresSafeArea()
    }
}
