//
//  ScriptStoreRequest.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

struct StoreScriptRequest : Codable{
    let script: String
    let gptId: String
    let title: String
    let secTime: Int
}
