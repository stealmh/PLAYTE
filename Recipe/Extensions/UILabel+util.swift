//
//  UILabel+util.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/10.
//

import UIKit

extension UILabel {
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    /// @다음 문자열까지의 색깔 조절
    func highlightMentions(withColor color: UIColor) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let regexPattern = "@[^\\s]+"
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
            }
            
            self.attributedText = attributedString
        } catch {
            print("정규화 실패: \(error.localizedDescription)")
        }
    }
}
