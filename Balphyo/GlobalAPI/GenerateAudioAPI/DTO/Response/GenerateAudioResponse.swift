//
//  GenerateAudioResponse.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

struct GenerateAudioResponse : Codable {
    let profileUrl : String
    let playTime: Int
    let speechMarks: [SpeechMark]
}

struct SpeechMark : Codable {
    var start: Int  // 초 단위
    var end: Int    // 초 단위
    var time: Int
    var type: String
    var value: String
}
