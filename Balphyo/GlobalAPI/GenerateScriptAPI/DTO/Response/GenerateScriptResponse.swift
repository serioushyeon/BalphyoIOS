//
//  GenerateScriptResponse.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

struct GenerateScriptResponse : Codable {
    let code: String
    let message: String
    let result: GenerateScrpitResult
}

struct GenerateScrpitResult : Codable {
    let resultScript: [ResultScript]
    let gptId: String
}

struct ResultScript : Codable {
    let index: Int
    let message: Message
    let logprobs: Bool?
    let finish_reason: String
}

struct Message : Codable {
    let role: String
    let content: String
}
