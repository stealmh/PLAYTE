//
//  PageSectionFooterView.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit

struct PagingInfo: Equatable, Hashable {
    let sectionIndex: Int
    let currentPage: Int
}

class PagingSectionFooterView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    private let headerBackground: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 30
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        v.layer.masksToBounds = false
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0 , height:3)
        
        return v
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = true
        control.currentPageIndicatorTintColor = .systemOrange
        control.pageIndicatorTintColor = .systemGray5
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubViews(headerBackground, pageControl)
        
        pageControl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        headerBackground.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview()
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
