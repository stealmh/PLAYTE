//
//  CategoryModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/28.
//

import Foundation

struct CategoryModel: Codable {
    let actionAdventure, actionComedies, actionSciFiFantasy, actionThrillers: [Item]

    enum CodingKeys: String, CodingKey, CaseIterable {
        case actionAdventure = "Action & Adventure"
        case actionComedies = "Action Comedies"
        case actionSciFiFantasy = "Action Sci-Fi & Fantasy"
        case actionThrillers = "Action Thrillers"
    }
}

// MARK: - Action
struct Item: Codable, Equatable {
    let name: String
}
