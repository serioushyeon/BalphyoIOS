//
//  LoginTarget.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire

enum LoginTarget {
    case generateUid
    case verifyUid
}

extension LoginTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .generateUid:
            return .post
        case .verifyUid:
            return .get
        }
        
    }
    
    var path: String {
        switch self {
        case .generateUid:
            return "guest/manage/uid"
        case .verifyUid:
            return "guest/manage/uid"
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case .generateUid:
            return .requestPlain
        case .verifyUid:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .generateUid:
            return .plain
        case .verifyUid:
            return .hasToken
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .generateUid:
            return .unauthorization
        case .verifyUid:
            return .authorization
        }
    }

}
