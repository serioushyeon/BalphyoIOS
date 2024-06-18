//
//  ScriptCrudTarget.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire

enum ScriptCrudTarget {
    case storeScript(_ bodyDTO: StoreScriptRequest)
    case getScriptList
    case getScriptDetail(_ bodyDTO: ScriptDetailDeleteRequest)
    case deleteScript(_ bodyDTO: ScriptDetailDeleteRequest)
    case editScript(_ bodyDTO: ScriptEditRequest)
}

extension ScriptCrudTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .storeScript:
            return .post
        case .getScriptList:
            return .get
        case .getScriptDetail:
            return .get
        case .deleteScript:
            return .delete
        case .editScript:
            return .patch
        }
        
    }
    
    var path: String {
        switch self {
        case .storeScript:
            return "every/manage/script"
        case .getScriptList:
            return "every/manage/script/all"
        case let .getScriptDetail(bodyDTO):
            return "every/manage/script/detail/\(bodyDTO.scriptId)"
        case let .deleteScript(bodyDTO):
            return "every/manage/script/detail/\(bodyDTO.scriptId)"
        case let .editScript(bodyDTO):
            return "every/manage/script/detail/\(bodyDTO.scriptId)"
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case let .storeScript(bodyDTO):
            return .requestWithBody(bodyDTO)
        case .getScriptList:
            return .requestPlain
        case let .getScriptDetail(bodyDTO):
            return .requestQuery(bodyDTO)
        case let .deleteScript(bodyDTO):
            return .requestQuery(bodyDTO)
        case let .editScript(bodyDTO):
            return .requestQueryWithBody(bodyDTO.scriptId, bodyParameter: bodyDTO)
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .storeScript:
            return .hasToken
        case .getScriptList:
            return .hasToken
        case .getScriptDetail:
            return .hasToken
        case .deleteScript:
            return .hasToken
        case .editScript:
            return .hasToken
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .storeScript:
            return .authorization
        case .getScriptList:
            return .authorization
        case .getScriptDetail:
            return .authorization
        case .deleteScript:
            return .authorization
        case .editScript:
            return .authorization
        }
    }

}
