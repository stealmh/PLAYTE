//
//  CommentRecipeCell.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol CommentRecipeCellDelegate: AnyObject {
    func didTappedReplyButton(_ id: Int, _ nickName: String, _ index: Int, _ section: Int)
    func didTappedLikeButton(_ id: Int, _ index: Int, _ section: Int)
    func didTappedReportButton(_ id: Int, _ index: Int, _ section: Int)
}

class CommentRecipeCell: UITableViewCell {
    
    var indexNumber = 0
    var replyID = 0
    var section = 0

    let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .grayScale5
        return v
    }()
    private let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = .grayScale4
        return v
    }()
    private let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "heart_review_svg"), for: .normal)// 이미지 넣기
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight //<- 중v
        v.imageEdgeInsets = .init(top: 2, left: -5, bottom: 0, right: 0) //<- 중요
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitleColor(.grayScale3, for: .normal)
        return v
    }()
    private let singoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "ban_empty_svg"), for: .normal)// 이미지 넣기
        return v
    }()
    private let comment: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .grayScale5
        v.numberOfLines = 10
        return v
    }()
    private let commentBackground: UIView = {
        let v = UIView()
//        v.layer.cornerRadius = 22.5
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "F8F8F8")
        return v
    }()
    private let replyButton: UIButton = {
        let v = UIButton()
        v.setTitle("답글", for: .normal)
        v.setTitleColor(.replyColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 12)
        return v
    }()
    
    weak var delegate: CommentRecipeCellDelegate?
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        configureLayout()
        mockConfigure()
        backgroundColor = .clear
        
        singoButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedReportButton(self.replyID, self.indexNumber, self.section)
            }).disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedLikeButton(self.replyID, self.indexNumber, self.section)
            }).disposed(by: disposeBag)
        
        replyButton.rx.tap
            .subscribe(onNext: { _ in
                if let text = self.nickNameLabel.text {
                    self.delegate?.didTappedReplyButton(self.replyID, text, self.indexNumber, self.section)
                }
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentBackground.roundCorners(tl: 5, tr: 22.5, bl: 22.5, br: 22.5)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func addView() {
//        addSubViews(nickNameLabel, uploadTimeLabel, likeButton, singoButton, commentBackground,comment, replyButton)
        contentView.addSubViews(nickNameLabel, uploadTimeLabel, likeButton, singoButton, commentBackground,comment, replyButton)
    }
    func configureLayout() {
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().inset(40)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.greaterThanOrEqualTo(17)
        }
        
        uploadTimeLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.left.equalTo(nickNameLabel.snp.right).offset(5)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel).offset(-5)
            $0.height.equalTo(singoButton)
            $0.width.equalTo(40)
            $0.right.equalTo(singoButton.snp.left).offset(-10)
        }
        
//        singoButton.backgroundColor = .blue
        singoButton.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel).offset(-5)
            $0.right.equalTo(replyButton)
            $0.width.equalTo(30)
            $0.height.greaterThanOrEqualTo(30)
        }
        
        commentBackground.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel).inset(35)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(40)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        comment.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.left.right.equalTo(commentBackground).inset(20)
            $0.height.equalTo(commentBackground)
        }
        
        replyButton.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.right.equalTo(singoButton)
            $0.width.equalTo(30)
            $0.left.equalTo(commentBackground.snp.right)
            //            $0.height.equalTo(14)
        }
    }
    //for data inject
//    func configure(_ item: Comment) {
//        myTitle.text = item.nickName
//        uploadTimeLabel.text = item.uploadTime
//        likeButton.setTitle("\(item.like)", for: .normal)
//        comment.text = item.comment
//    }
    func mockConfigure() {
        nickNameLabel.text = "자칭 얼리어답터"
        uploadTimeLabel.text = "1시간 전"
        likeButton.setTitle("23", for: .normal)
        comment.text = "너무 좋은 레시피 입니다."
    }
    
    func setCollapsed(collapsed: Bool) {
        //        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
    
    func configure(_ item: ReplyList, index: Int, section: Int) {
        print("configure item::", item)
        self.replyID = item.reply_id
        self.section = section
        DispatchQueue.main.async {
            if let timeConvert = item.created_at.timeAgo() {
                self.uploadTimeLabel.text = timeConvert
            }
            self.nickNameLabel.text = item.reply_writtenby
            self.comment.text = item.reply_content
            self.comment.highlightMentions(withColor: .mainColor ?? .orange)
            self.likeButton.setTitle("\(item.reply_likes)", for: .normal)
            if item.is_likes {
                self.likeButton.setImage(UIImage(named:"heart_review_fill_svg"), for: .normal)
                self.likeButton.setTitleColor(.mainColor, for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named:"heart_review_svg"), for: .normal)
                self.likeButton.setTitleColor(.grayScale3, for: .normal)
            }
            self.indexNumber = index
        }
    }
}
