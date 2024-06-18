//
//  GenerateScriptViewModel.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Combine

class GenerateScriptManager: ObservableObject {
    static let shard = GenerateScriptManager()
    
    var topic: String = ""
    var keywords: String = ""
    var secTime: Int = 180
    var balpyoAPIKey: String = "1234"
    var test: String = "false"
    var title: String = ""
    var gptId: String = ""
    var script: String = ""
    
}
