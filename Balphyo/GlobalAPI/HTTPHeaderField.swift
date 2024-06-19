//
//  HTTPHeaderField.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case accessToken = "accessToken"
    case refreshtoken = "refreshtoken"
    case providerToken = "X-Provider-Token"
    case uid = "UID"
}

enum HTTPHeaderFieldValue: String {
    case multipartformData = "multipart/form-data"
    case json = "Application/json"
    case accessToken
    case audio = "audio/mp3"
}

enum HTTPHeaderType {
    case plain
    case hasToken
    case audio
    /*case providerToken
    case refreshToken*/
}

@frozen
enum Authorization {
    case authorization
    case unauthorization
    case socialAuthorization
    case reAuthorization
}
