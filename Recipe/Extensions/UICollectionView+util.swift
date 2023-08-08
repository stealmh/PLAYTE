//
//  UICollectionView+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/09.
//

import UIKit

extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(cellType: Cell.Type) {
        self.register(cellType, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerHeaderView<View: UICollectionReusableView>(viewType: View.Type) {
        self.register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: View.reuseIdentifier)
    }

    func registerFooterView<View: UICollectionReusableView>(viewType: View.Type) {
        self.register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: View.reuseIdentifier)
    }

}
