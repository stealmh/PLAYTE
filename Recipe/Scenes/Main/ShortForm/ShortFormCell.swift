//
//  TestCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/02.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

protocol ShortFormCellDelegate: AnyObject {
    func didTapVideo(videoURL: URL?, player: AVPlayer, playerLayer: AVPlayerLayer)
}

class ShortFormCell: UICollectionViewCell {
    
    private let shortFormbackground: UIView = {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var player: AVPlayer = AVPlayer(playerItem: nil)

    private lazy var playerLayer: AVPlayerLayer = {
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
    
    private let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormHeart"), for: .normal)
        v.setTitle("132", for: .normal)
        v.alignTextBelow(spacing: 10)
        return v
    }()
    
    private let commentButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormComment"), for: .normal)
        v.setTitle("56", for: .normal)
        v.alignTextBelow(spacing: 10)
        return v
    }()
    
    private let favoriteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "shortFormFavorite"), for: .normal)
        v.setTitle("21", for: .normal)
        v.alignTextBelow(spacing: 10)
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
        v.image = UIImage(named: "watch")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    weak var delegate: ShortFormCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        configureLayout()
        mockConfigure()
        self.shortFormbackground.layer.addSublayer(self.playerLayer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        // AVPlayerViewController를 모달로 표시합니다.
        delegate?.didTapVideo(videoURL: URL(string: ""), player: player, playerLayer: playerLayer)
        
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
        player.replaceCurrentItem(with: nil)
        self.stop()
    }
}

//MARK: - Method(Normal)
extension ShortFormCell {
    func addView() {
        addSubViews(shortFormbackground, watchImageView, playtimeLabel, likeButton, commentButton, favoriteButton, nickNameLabel, explanationLabel)
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
            $0.right.equalTo(shortFormbackground).inset(20)
            $0.width.equalTo(30)
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
    }
    func mockConfigure() {
        playtimeLabel.text = "00:49"
        nickNameLabel.text = "happyday125"
        explanationLabel.text = "탕후루를 집에서 손쉽게 만드는 법을 공개합니다"
    }
    
    func playVideo(url: String) {
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        player.replaceCurrentItem(with: playerItem)
        player.volume = 0
        player.play()
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
