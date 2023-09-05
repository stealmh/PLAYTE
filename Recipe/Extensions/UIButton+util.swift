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
    
    func alignTextBelow(spacing: CGFloat = 4.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func setUnderlineForText(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
