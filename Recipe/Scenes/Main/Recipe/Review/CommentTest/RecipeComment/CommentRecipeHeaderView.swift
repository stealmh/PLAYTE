//
//  CommentRecipeHeaderView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol CommentHeaderViewDelegate: AnyObject {
    func toggleSection(header: CustomFirstTableViewHeaderFooterViewForRecipe, section: Int)
    func didTappedReplyButton(_ nickName: String, id: Int)
    func didTappedLikeButton(id: Int, section: Int)
    func didTappedReportButton(id: Int, section: Int)
}

class CommentRecipeHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    var section: Int = 0
    
    weak var delegate: CommentHeaderViewDelegate?
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
//    @objc private func didTapHeader() {
//        delegate?.toggleSection(header: self, section: section)
//    }
    
    func setCollapsed(collapsed: Bool) {
        //        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
}


class CustomFirstTableViewHeaderFooterViewForRecipe: UITableViewHeaderFooterView {
    weak var delegate: CommentHeaderViewDelegate?
    var section: Int = 0
    var commentID: Int = 0
    let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .grayScale5
        return v
    }()
    let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = .grayScale4
        return v
    }()
    let likeButton: UIButton = {
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
    
    let singoButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "ban_empty_svg"), for: .normal)// 이미지 넣기
        return v
    }()
    
    let comment: UILabel = {
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
    
    private let disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addView()
        configureLayout()
        mockConfigure()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))

        replyButton.rx.tap
            .subscribe(onNext: { _ in
                if let text = self.nickNameLabel.text {
                    self.delegate?.didTappedReplyButton(text, id: self.commentID)
                }
            }).disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedLikeButton(id: self.commentID, section: self.section)
            }).disposed(by: disposeBag)
        
        singoButton.rx.tap
            .subscribe(onNext: { _ in
                self.delegate?.didTappedReportButton(id: self.commentID, section: self.section)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentBackground.roundCorners(tl: 5, tr: 22.5, bl: 22.5, br: 22.5)
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
}

extension CustomFirstTableViewHeaderFooterViewForRecipe {
    func addView() {
        addSubViews(nickNameLabel, uploadTimeLabel, likeButton, singoButton, commentBackground,comment, replyButton)
    }
    func configureLayout() {

        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
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
//        nickNameLabel.text = item.nickName
//        uploadTimeLabel.text = item.uploadTime
//        likeButton.setTitle("\(item.like)", for: .normal)
//        comment.text = item.comment
//    }
    func mockConfigure() {
        nickNameLabel.text = "자칭 얼리어답터"
        uploadTimeLabel.text = "1시간 전"
        likeButton.setTitle("23", for: .normal)
        comment.text = "너무 좋은 레시피 입니당."
    }
    
    func setCollapsed(collapsed: Bool) {
        //        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
    
    func configure( _ item: ExpandableCategories, section: Int) {
        print("\(#function) configure")
        print(item)
        self.commentID = item.comment_id
        
        if let timeSting = item.uploadTime.timeAgo() {
            uploadTimeLabel.text = item.uploadTime.timeAgo()
        }
        nickNameLabel.text = item.categoryHeader
        comment.text = item.content
        likeButton.setTitle("\(item.cooment_likes)", for: .normal)
        if item.is_liked {
            likeButton.setImage(UIImage(named:"heart_review_fill_svg"), for: .normal)
            likeButton.setTitleColor(.mainColor, for: .normal)
        } else {
            likeButton.setImage(UIImage(named:"heart_review_svg"), for: .normal)
            likeButton.setTitleColor(.grayScale3, for: .normal)
        }
        self.section = section
    }
}


//MARK: - VC Preview
import SwiftUI
struct CommentRecipeVC_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentViewController(comment: RecipeComment(code: "", data: CommentContents(content: [CommentInfo(comment_content: "컨텐츠입니다.", comment_id: 0, comment_likes: 10, comment_writtenby: "미노", created_at: "2023-03-16", is_liked: true, replyList: [ReplyList(created_at: "2023-03-16", is_likes: true, reply_content: "리플 컨텐츠입니다", reply_id: 2, reply_likes: 0, reply_writtenby: "미노리플")])])), divideId:0)).toPreview()
    }
}
