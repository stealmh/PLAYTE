//
//  CommentFooterView.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/31.
//

import UIKit
import SnapKit

protocol CommentFooterViewDelegate: AnyObject {
    func toggleSection(header: CommentFooterView, section: Int)
}

class CommentFooterView: UITableViewHeaderFooterView {
    weak var delegate: CommentFooterViewDelegate?
    var section: Int = 0
    
    private let applyLine: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrayLine")
        return v
    }()
    
    private let applyLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = UIColor.hexStringToUIColor(hex: "616169")
        return v
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addView()
//        configureLayout()
//        didOpenLayout()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyLabel.text = nil
        
        
        applyLine.snp.removeConstraints()
        applyLabel.snp.removeConstraints()
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
}

extension CommentFooterView {
    func addView() {
        addSubViews(applyLine, applyLabel)
    }
    
    /// 기본상태에서의 레이아웃
    func configureLayout(applyCount: Int) {
        if applyCount > 0 {
            applyLine.isHidden = false
            applyLine.snp.remakeConstraints {  // remakeConstraints를 사용하여 기존 제약 조건을 제거하고 새로 설정합니다.
                $0.top.equalToSuperview().inset(20)
                $0.left.equalToSuperview().inset(40)
                $0.width.equalTo(26)
                $0.height.equalTo(12)
            }

            ///Todo:  에러원인 찾기
//            applyLabel.text = "답글 \(applyCount)개 보기"
            applyLabel.text = "답글보기"
            applyLabel.snp.remakeConstraints {
                $0.top.equalTo(applyLine).offset(-3)
                $0.left.equalTo(applyLine.snp.right).offset(7)
                $0.width.equalTo(100)
                $0.height.equalTo(26)
            }
        } else {
            applyLine.isHidden = true
        }
    }
    //for data inject
    func didOpenLayout(applyCount: Int) {
        if applyCount > 0 {
            applyLine.isHidden = false
            applyLine.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.left.equalToSuperview().inset(60)
                $0.width.equalTo(26)
                $0.height.equalTo(12)
            }

            applyLabel.text = "답글숨기기"
            applyLabel.snp.remakeConstraints {
                $0.top.equalTo(applyLine).offset(-5)
                $0.left.equalTo(applyLine.snp.right).offset(10)
                $0.width.equalTo(100)
                $0.height.equalTo(26)
            }
        } else {
            applyLine.isHidden = true
        }
    }

    
    func setCollapsed(collapsed: Bool, applyCount: Int) {
        if collapsed {
            configureLayout(applyCount: applyCount)
        } else {
            didOpenLayout(applyCount: applyCount)
        }
    }
}

//MARK: - VC Preview
import SwiftUI
struct Comment_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentViewController(comment: RecipeComment(code: "", data: CommentContents(content: [CommentInfo(comment_content: "컨텐츠입니다.", comment_id: 0, comment_likes: 10, comment_writtenby: "미노", created_at: "2023-03-16", is_liked: false, replyList: [ReplyList(created_at: "2023-03-16", is_likes: false, reply_content: "리플 컨텐츠입니다", reply_id: 2, reply_likes: 0, reply_writtenby: "미노리플")])])), divideId:0)).toPreview()
    }
}
