//
//  UIColor+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/10.
//

import UIKit

extension UIColor {
    class var mainColor: UIColor? { return UIColor(named: "MainColor") }
    class var lineColor: UIColor? { return UIColor(named: "LineColor") }
    class var replyColor: UIColor? { return UIColor(named: "reply") }
    
    class var sub1: UIColor? { return UIColor(named: "Sub1") }
    class var sub2: UIColor? { return UIColor(named: "Sub2") }
    class var sub3: UIColor? { return UIColor(named: "Sub3") }
    class var sub4: UIColor? { return UIColor(named: "Sub4") }
    
    class var grayScale1: UIColor? { return UIColor(named: "GrayScale1") }
    class var grayScale2: UIColor? { return UIColor(named: "GrayScale2") }
    class var grayScale3: UIColor? { return UIColor(named: "GrayScale3") }
    class var grayScale4: UIColor? { return UIColor(named: "GrayScale4") }
    class var grayScale5: UIColor? { return UIColor(named: "GrayScale5") }
    class var grayScale6: UIColor? { return UIColor(named: "GrayScale6") }
    
    static func hexStringToUIColor (hex: String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }

            if ((cString.count) != 6) {
                return UIColor.gray
            }

            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
}
