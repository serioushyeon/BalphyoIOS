//
//  ScriptListResponse.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation

struct ScriptListResponse : Codable {
    let code: String
    let message: String
    let result: [ScriptListResult]
}

struct ScriptListResult : Codable {
    let scriptId: Int
    let script: String?
    let gptId: String?
    let uid: String
    let title: String
    let secTime: Int
    let voiceFilePath: String?
}

