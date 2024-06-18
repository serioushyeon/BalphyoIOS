//
//  ScriptEditRequest.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
struct ScriptEditRequest : Codable {
    let scriptId: Int
    let script: String
    let title: String
    let secTime: Int
}
