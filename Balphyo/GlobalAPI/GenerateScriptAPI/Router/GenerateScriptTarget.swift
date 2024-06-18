//
//  GenerateScriptTarget.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire

enum GenerateScriptTarget {
    case generateScript(_ bodyDTO: GenerateScriptRequest)
}

extension GenerateScriptTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .generateScript:
            return .post
        }
        
    }
    
    var path: String {
        switch self {
        case .generateScript:
            return "user/ai/script"
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case let .generateScript(bodyDTO):
            return .requestWithBody(bodyDTO)
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .generateScript:
            return .hasToken
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .generateScript:
            return .authorization
        }
    }

}
