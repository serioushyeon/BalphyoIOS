//
//  ScriptTimeManager.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation

class ScriptTimeManager: ObservableObject {
    static let shard = ScriptTimeManager()
    
    var topic: String = ""
    var keywords: String = ""
    var secTime: Int = 180
    var balpyoAPIKey: String = "1234"
    var test: String = "false"
    var title: String = ""
    var gptId: String = ""
    var script: String = ""
    var speed: Int = 0
    
}
