//
//  GenerateScriptRequest.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

struct GenerateScriptRequest : Codable{
    let topic: String
    let keywords: String
    let secTime: Int
    let balpyoAPIKey: String
    let test: String
}
