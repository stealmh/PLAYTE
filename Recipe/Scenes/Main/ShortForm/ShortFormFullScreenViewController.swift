//
//  ShortFormFullScreenViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

class ShortFormFullScreenViewController: BaseViewController {
    var videoURL: URL?
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    
    /// UI Properties
    private let background = ShortFormFullScreenView()
    private var slider: UISlider = {
        let v = UISlider()
        v.thumbTintColor = .mainColor
        v.minimumTrackTintColor = .mainColor
        v.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        return v
    }()
    
    //    private let pausePlayButton: UIButton = {
    //        let v = UIButton()
    //        v.setImage(UIImage(named: "pause_svg"), for: .normal)
    //        v.isEnabled = false
    //        return v
    //    }()
    
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
    
    /// Properties
    private let disposeBag = DisposeBag()
    private var soundToggle = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        stackView.addArrangeViews( currentPlayTimeLabel, totalPlayTimeLabel)
        view.addSubview(background)
        view.addSubview(slider)
        view.addSubview(stackView)
        configureLayout()
        defaultNavigationBackButton(backButtonColor: .white)
        setupUI()
        self.bind()
        view.backgroundColor = .gray
        
        //        let moreButton = UIBarButtonItem.menuButtonTap(imageName: "more_svg", size: CGSize(width: 40, height: 40))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more_svg"), style: .plain, target: self, action: #selector(moreButtonTapped))
        let soundButton = UIBarButtonItem(image: UIImage(named: "soundplay_svg1"), style: .plain, target: self, action: #selector(speakerButtonTapped))
        
        let rightBarButtonItems = [moreButton, soundButton]
        
        // 바 버튼 아이템들을 화면의 navigationItem에 설정합니다.
        navigationItem.rightBarButtonItems = rightBarButtonItems
        /*
         asdas asdasdasd asdasda sd asda das das das
         */
    }
    
    @objc func moreButtonTapped(sender: UIBarButtonItem) {
        
        let customViewController = ShortFormSheetViewController()
        customViewController.modalPresentationStyle = .custom
        customViewController.transitioningDelegate = self

        present(customViewController, animated: true, completion: nil)
        
    }
    
    @objc func speakerButtonTapped(sender: UIBarButtonItem) {
        print("tapped")
        soundToggle.toggle()
        if soundToggle {
            player.volume = 30
            sender.image = UIImage(named: "soundplay_svg1")
        } else {
            player.volume = 0
            sender.image = UIImage(named: "soundplayStop_svg")
        }
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
        //        self.tabBarController?.tabBar.isHidden = true
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        player.replaceCurrentItem(with: nil)
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
        
        //        pausePlayButton.snp.makeConstraints {
        //            $0.top.left.height.equalTo(stackView)
        //            $0.width.equalTo(20)
        //        }
        
        currentPlayTimeLabel.snp.makeConstraints {
            $0.top.height.equalTo(stackView)
            $0.left.equalTo(stackView).offset(20)
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
        player.volume = 30
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        
        // 재생 위치 변경을 감지하는 옵저버를 추가합니다.
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
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

extension ShortFormFullScreenViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        PresentationController(presentedViewController: presented, presenting: presenting)
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 205)
    }
    
    func bind() {
        let vc = CommentTestViewController()
        
        background.commentButton.rx.tap
            .subscribe(onNext: { _ in
                if #available(iOS 15.0, *) {
                    guard let sheet = vc.sheetPresentationController else { return }
                    sheet.detents = [.medium(), .large()]
                    sheet.preferredCornerRadius = 20
                    sheet.prefersGrabberVisible = true
                } else {
                    vc.modalPresentationStyle = .automatic
                    vc.transitioningDelegate = self
                }
                self.present(vc, animated: true)
            }).disposed(by: disposeBag)
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
            stopPlayAnimation(img: UIImage(named: "viewstop_svg")!,width: 50,height: 50)
            //            pausePlayButton.setImage(UIImage(named: "play_svg"), for: .normal)
        } else { // 일시정지 상태
            player.play()
            stopPlayAnimation(img: UIImage(named: "viewplay_svg")!,width: 50,height: 50)
            //            pausePlayButton.setImage(UIImage(named: "pause_svg"), for: .normal)
        }
    }
}

//MARK: - VC Preview
import SwiftUI
import AVKit
struct ShortFormViewController1_preview: PreviewProvider {
    static var previews: some View {
        //        UINavigationController(rootViewController: ShortFormFullScreenViewController(videoURL: nil, player: AVPlayer(), playerLayer: AVPlayerLayer()))
        //            .toPreview()
        //            .ignoresSafeArea()
        UINavigationController(rootViewController: ShortFormViewController())
            .toPreview()
            .ignoresSafeArea()
    }
}
