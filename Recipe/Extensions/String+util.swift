//
//  String+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import Foundation
import UIKit

extension String {
    func isValidNickname() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let regexPattern = "^[가-힣a-zA-Z0-9]{2,6}$"
        let regex = try! NSRegularExpression(pattern: regexPattern)
        
        let isValid = regex.firstMatch(in: trimmed, range: NSRange(location: 0, length: trimmed.utf16.count)) != nil
        
        return isValid
    }
    
    func timeAgo() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withFractionalSeconds, .withColonSeparatorInTime]
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        if let year = diffComponents.year, year > 0 {
            return "\(year)년 전"
        }
        
        if let month = diffComponents.month, month > 0 {
            return "\(month)개월 전"
        }
        
        if let day = diffComponents.day, day > 0 {
            return "\(day)일 전"
        }
        
        if let hour = diffComponents.hour, hour > 0 {
            return "\(hour)시간 전"
        }
        
        if let minute = diffComponents.minute, minute > 0 {
            return "\(minute)분 전"
        }
        
        return "방금 전"
    }
    
    func toDateFormatted() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func base64ToImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
    
    var encoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}
