//
//  CommentTestHeaderView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/28.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func toggleSection(header: CustomFirstTableViewHeaderFooterView, section: Int)
}

class CommentTestHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    var section: Int = 0
    
    weak var delegate: HeaderViewDelegate?
    
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


extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
}

class CustomFirstTableViewHeaderFooterView: UITableViewHeaderFooterView {
    weak var delegate: HeaderViewDelegate?
    var section: Int = 0
    let nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 14)
        v.textColor = .replyColor
        return v
    }()
    private let uploadTimeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = .replyColor
        return v
    }()
    private let likeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "like"), for: .normal)
        v.setTitleColor(.mainColor, for: .normal)
        v.tintColor = .gray
        v.imageView?.contentMode = .scaleAspectFit
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.contentHorizontalAlignment = .center
        v.semanticContentAttribute = .forceLeftToRight
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let declarationButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "warnning"), for: .normal)
        return v
    }()
    private let comment: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = .replyColor
        v.numberOfLines = 10
        return v
    }()
    private let commentBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 22.5
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.backgroundColor = .gray.withAlphaComponent(0.3)
        
        return v
    }()
    private let replyButton: UIButton = {
        let v = UIButton()
        v.setTitle("답글", for: .normal)
        v.setTitleColor(.replyColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 12)
        return v
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addView()
        configureLayout()
        mockConfigure()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
}

extension CustomFirstTableViewHeaderFooterView {
    func addView() {
        addSubViews(nickNameLabel, uploadTimeLabel, likeButton, declarationButton, comment, commentBackground, replyButton)
    }
    func configureLayout() {
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.greaterThanOrEqualTo(17)
        }
        
        uploadTimeLabel.snp.makeConstraints {
            $0.top.height.equalTo(nickNameLabel)
            $0.left.equalTo(nickNameLabel.snp.right).offset(5)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel)
            $0.width.greaterThanOrEqualTo(30)
            $0.right.equalTo(declarationButton.snp.left).offset(-10)
            $0.height.greaterThanOrEqualTo(14)
        }
        
        declarationButton.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(17.05)
            $0.height.greaterThanOrEqualTo(18)
        }
        
        commentBackground.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel).inset(20)
            $0.left.equalTo(nickNameLabel)
            $0.right.equalTo(likeButton).inset(10)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        comment.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.left.right.equalTo(commentBackground).inset(20)
            $0.height.equalTo(commentBackground)
        }
        
        replyButton.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.right.equalTo(declarationButton)
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
        comment.text = "너무 좋은 레시피 입니다."
    }
    
    func setCollapsed(collapsed: Bool) {
        //        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
}
