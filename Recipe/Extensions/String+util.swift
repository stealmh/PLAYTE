//
//  String+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation

extension String {
    func isValidNickname() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)

        let regexPattern = "^[가-힣a-zA-Z0-9]{2,6}$"
        let regex = try! NSRegularExpression(pattern: regexPattern)
        
        let isValid = regex.firstMatch(in: trimmed, range: NSRange(location: 0, length: trimmed.utf16.count)) != nil
        
        return isValid
    }
}
