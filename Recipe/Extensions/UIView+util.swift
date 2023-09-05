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
    
    /// 사진의 배경색을 어둡게 만들어 줌
    func addoverlay(color: UIColor = .black, alpha : CGFloat = 0.6) {
        let v = UIView()
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.frame = bounds
        v.backgroundColor = color
        v.alpha = alpha
        addSubview(v)
    }
    
    func roundCorners(tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat) {
        let path = UIBezierPath()
        let size = self.bounds.size
        
        // Start at top-left
        path.move(to: CGPoint(x: 0.0 + tl, y: 0.0))
        path.addLine(to: CGPoint(x: size.width - tr, y: 0.0))
        path.addArc(withCenter: CGPoint(x: size.width - tr, y: 0.0 + tr), radius: tr, startAngle: -CGFloat.pi/2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: size.width, y: size.height - br))
        path.addArc(withCenter: CGPoint(x: size.width - br, y: size.height - br), radius: br, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: 0.0 + bl, y: size.height))
        path.addArc(withCenter: CGPoint(x: 0.0 + bl, y: size.height - bl), radius: bl, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: CGPoint(x: 0.0, y: 0.0 + tl))
        path.addArc(withCenter: CGPoint(x: 0.0 + tl, y: 0.0 + tl), radius: tl, startAngle: CGFloat.pi, endAngle: -CGFloat.pi/2, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
