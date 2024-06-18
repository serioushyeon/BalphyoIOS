//
//  GenerateUidResponse.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

struct GenerateUidResponse : Codable {
    let code: String
    let message: String
    let result: UidResult?
}

struct UidResult : Codable {
    let uid: String
}
