//
//  VerifyUidResponse.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//
import Foundation

struct VerifyUidResponse : Codable {
    let code: String
    let message: String
    let result: VerifyUidResult?
}

struct VerifyUidResult : Codable {
    let yourUID: String
    let verified: Bool
}
