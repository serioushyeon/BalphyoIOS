//
//  GenerateAudioRequest.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

struct GenerateAudioRequest : Codable {
    let text: String
    let speed: Int
    let balpyoAPIKey: String
}
