//
//  ScriptDetailResponse.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
struct ScriptDetailResponse : Codable {
    let code: String
    let message: String
    let result: ScriptDetailResult
}

struct ScriptDetailResult : Codable {
    let scriptId: Int
    let script: String
    let gptId: String?
    let uid: String
    let title: String
    let secTime: Int
}
