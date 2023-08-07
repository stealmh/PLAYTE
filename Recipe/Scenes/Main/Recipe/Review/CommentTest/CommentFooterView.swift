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
        applyLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(26)
            $0.height.equalTo(12)
        }
        /// test
        applyLabel.text = "답글 \(applyCount)개 보기"
        applyLabel.snp.makeConstraints {
            $0.top.equalTo(applyLine)
            $0.left.equalTo(applyLine.snp.right).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(26)
        }
    }
    //for data inject
    func didOpenLayout() {
        applyLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(60)
            $0.width.equalTo(26)
            $0.height.equalTo(12)
        }
        /// test
        applyLabel.text = "답글숨기기"
        applyLabel.snp.makeConstraints {
            $0.top.equalTo(applyLine)
            $0.left.equalTo(applyLine.snp.right).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(26)
        }
    }

    
    func setCollapsed(collapsed: Bool, applyCount: Int) {
        if collapsed {
            configureLayout(applyCount: applyCount)
        } else {
            didOpenLayout()
        }
    }
}

//MARK: - VC Preview
import SwiftUI
struct CommentTest_preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CommentTestViewController()).toPreview()
    }
}
