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
    var item: ShortFormInfo
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    
    /// UI Properties
    private lazy var background = ShortFormFullScreenView(item: item)
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
    var viewModel = ShortFormFullScreenViewModel()
    private let disposeBag = DisposeBag()
    private var soundToggle = true
    private var gestureRecognizer: UITapGestureRecognizer!
    
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
        Task {
            await self.bind()
        }
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
        background.getItemRelay.accept(item)
    }
    
    @objc func moreButtonTapped(sender: UIBarButtonItem) {
        
        let customViewController = ShortFormSheetViewController()
        customViewController.modalPresentationStyle = .custom
        customViewController.transitioningDelegate = self
        customViewController.delegate = self
        
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
    
    init(item: ShortFormInfo, player: AVPlayer, playerLayer: AVPlayerLayer) {
        // 초기화 코드 추가
        self.player = player
        self.playerLayer = playerLayer
        self.item = item
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
        //        self.tabBarController?.tabBar.isHidden = false
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
            $0.height.equalToSuperview().inset(30)
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
        guard let url = URL(string: item.video_url) else { return }
        player = AVPlayer(url: url)
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
            
            if duration.isNaN || duration.isInfinite {
                print("Duration is not a valid number: \(duration)")
            }
            
            if currentTime.isNaN || currentTime.isInfinite {
                print("Current time is not a valid number: \(currentTime)")
            }
            
            if player.currentItem?.status == .readyToPlay {
                // 현재 시청한 시간
                let currentSeconds = Int(currentTime)
                // 남은 전체 시간
                let remainingSeconds = Int(duration)
                
                self?.currentPlayTimeLabel.text = self?.timeString(from: currentSeconds)
                self?.totalPlayTimeLabel.text = " / " + (self?.timeString(from: remainingSeconds) ?? "")
            }
            
        }
        
        // 비디오가 끝났을 때 재생 시점을 처음으로 돌려주는 옵저버를 추가합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
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

//extension ShortFormFullScreenViewController: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        // Disable gesture recognizer when scrolling starts
//        gestureRecognizer.isEnabled = false
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Enable gesture recognizer when scrolling ends
//        gestureRecognizer.isEnabled = true
//    }
//    
//    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
//        // Handle tap gesture action here
//        if sender.state == .ended {
//            // Handle tap action when gesture recognizer is active
//        }
//    }
//}

extension ShortFormFullScreenViewController: UIViewControllerTransitioningDelegate, SheetActionDelegate {
    func didTappedUserReport() {
        print("id는->", item.writtenid)
        if !UserReportHelper.shared.isUserIdInUserReports(userId: Int64(item.writtenid)) {
            if UserReportHelper.shared.createUserReport(userId: Int64(item.writtenid)) {
                Task {
                    let data: DefaultReturnBool = try await NetworkManager.shared.get(.unsaveShortForm("\(item.shortform_id)"))
                }
                ShortFormCoreDataHelper.shared.deleteShortForm(byCode: item.shortform_id)
                self.dismiss(animated:true) {
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.showToastSuccess(message: "사용자가 차단되었습니다.")
                }
            }
        }
    }
    
    func didTappedNoInterest() {
        Task {
            if let data = await viewModel.notInterest(item.shortform_id), data.data {
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: false)
                }
                self.navigationController?.showToastSuccess(message: "관심없는 동영상으로 설정하였습니다.")
            }
            
        }
    }
    
    func didTappedReport() {
        
        Task {
            if let data = await viewModel.report(item.shortform_id), data.data {
                ShortFormCoreDataHelper.shared.deleteShortForm(byCode: item.shortform_id)
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: false)
                }
                self.navigationController?.showToastSuccess(message: "게시물을 신고하였습니다.")
            }
            
        }
        
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        //        PresentationController(presentedViewController: presented, presenting: presenting)
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedHeight: 205)
    }
    
    
    
    func bind() async {
        do {
            let a: RecipeComment = try await NetworkManager.shared.get(.shortformComment("\(item.shortform_id)"))
            let vc = CommentViewController(comment: a, divideId: item.shortform_id)
            
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
        } catch {
            print("error")
        }
        
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

struct UIViewControllerPreview<View: UIViewController>: UIViewControllerRepresentable {
    let viewController: View
    
    init(_ builder: @escaping () -> View) {
        viewController = builder()
    }
    
    func makeUIViewController(context: Context) -> View {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: View, context: Context) {
        // 업데이트 로직 추가 (선택 사항)
    }
}
