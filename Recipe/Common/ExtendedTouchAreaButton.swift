//
//  ExtendedTouchAreaButton.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/28.
//

import UIKit

class ExtendedTouchAreaButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = CGRect(x: bounds.origin.x,
                                    y: bounds.origin.y - 20,
                                    width: bounds.width,
                                    height: bounds.height + 20)
        return extendedBounds.contains(point)
    }
}
