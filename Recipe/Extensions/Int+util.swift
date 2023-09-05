//
//  Int+util.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/27.
//

import Foundation

extension Int {
    var formattedWithSeparator: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "\(numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)")"
    }
}
