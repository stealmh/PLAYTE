//
//  UploadResult.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/26.
//

import Foundation

struct UploadResult: Codable {
    let code: String
    let data: String
    let message: String
}
