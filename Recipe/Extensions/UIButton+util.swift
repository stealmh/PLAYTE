//
//  UIButton+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/11.
//

import UIKit

extension UIButton {
    func buttonImageSize(systemImageName: String, size: CGFloat) -> UIImage {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .light)
        let image = UIImage(systemName: systemImageName, withConfiguration: imageConfig)!
        return image
    }
    
    func buttonImageSize(imageName: String, size: CGFloat) -> UIImage {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .light)
        let image = UIImage(named: imageName, in: nil, with: imageConfig)!
        return image
    }
}
