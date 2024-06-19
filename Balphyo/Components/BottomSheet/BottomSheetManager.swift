//
//  Manager.swift
//  Balphyo
//
//  Created by jin on 6/19/24.
//

import Foundation

class BottomSheetManager: ObservableObject {
    static let shard = BottomSheetManager()
    
    var scriptList : [ScriptListResult]?
    var title: String = ""
    var script: String = ""
    
}
