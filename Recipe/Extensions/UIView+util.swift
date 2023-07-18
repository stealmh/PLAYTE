//
//  UIView+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/04.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addDashedBorder() {
        let color = UIColor.gray.withAlphaComponent(0.4).cgColor
        
        let v: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        v.bounds = shapeRect
        v.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        v.fillColor = UIColor.clear.cgColor
        v.strokeColor = color
        v.lineWidth = 2
        v.lineJoin = CAShapeLayerLineJoin.round
        v.lineDashPattern = [6,3]
        v.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(v)
    }
}
