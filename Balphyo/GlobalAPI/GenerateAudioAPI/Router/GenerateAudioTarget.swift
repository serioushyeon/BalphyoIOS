//
//  GenerateAudioTarget.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
import Alamofire

enum GenerateAudioTarget {
    case generateAudio(_ bodyDTO: GenerateAudioRequest)
}

extension GenerateAudioTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .generateAudio:
            return .post
        }
        
    }
    
    var path: String {
        switch self {
        case .generateAudio:
            return "polly/uploadSpeech"
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case let .generateAudio(bodyDTO):
            return .requestWithBody(bodyDTO)
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .generateAudio:
            return .audio
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .generateAudio:
            return .unauthorization
        }
    }

}
