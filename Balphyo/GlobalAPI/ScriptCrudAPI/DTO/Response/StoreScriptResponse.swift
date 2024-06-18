//
//  StoreScriptResponse.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation

struct StoreScriptResponse : Codable {
    let code: String
    let message: String
    let result: StoreScriptResult
}

struct StoreScriptResult : Codable {
    let script: String
    let gptId: String
    let uid: String
    let title: String
    let secTime: Int
    let voiceFilePath: String?
    let scriptId: String?
}
