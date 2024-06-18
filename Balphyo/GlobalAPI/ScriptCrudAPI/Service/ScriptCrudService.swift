//
//  ScriptCRUDService.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire


protocol ScriptCrudServiceProtocol {
    func storeScript(bodyDTO: StoreScriptRequest, completion: @escaping (NetworkResult<StoreScriptResponse>) -> Void)
    func getScriptList(completion: @escaping (NetworkResult<ScriptListResponse>) -> Void)
    func getScriptDetail(bodyDTO: ScriptDetailDeleteRequest, completion: @escaping (NetworkResult<ScriptDetailResponse>) -> Void)
    func deleteScript(bodyDTO: ScriptDetailDeleteRequest, completion: @escaping (NetworkResult<ScriptDeleteResponse>) -> Void)
    func editScript(bodyDTO: ScriptEditRequest, completion: @escaping (NetworkResult<ScriptEditResponse>) -> Void)
}

final class ScriptCrudService: APIRequestLoader<ScriptCrudTarget>, ScriptCrudServiceProtocol {
    
    func getScriptList(completion: @escaping (NetworkResult<ScriptListResponse>) -> Void) {
        fetchData(target: .getScriptList, responseData: ScriptListResponse.self, completion: completion)
    }
    
    func storeScript(bodyDTO: StoreScriptRequest, completion: @escaping (NetworkResult<StoreScriptResponse>) -> Void) {
        fetchData(target: .storeScript(bodyDTO), responseData: StoreScriptResponse.self, completion: completion)
    }
    
    func getScriptDetail(bodyDTO: ScriptDetailDeleteRequest, completion: @escaping (NetworkResult<ScriptDetailResponse>) -> Void) {
        fetchData(target: .getScriptDetail(bodyDTO), responseData: ScriptDetailResponse.self, completion: completion)
    }
    
    func deleteScript(bodyDTO: ScriptDetailDeleteRequest, completion: @escaping (NetworkResult<ScriptDeleteResponse>) -> Void) {
        fetchData(target: .deleteScript(bodyDTO), responseData: ScriptDeleteResponse.self, completion: completion)
    }
    
    func editScript(bodyDTO: ScriptEditRequest, completion: @escaping (NetworkResult<ScriptEditResponse>) -> Void) {
        fetchData(target: .editScript(bodyDTO), responseData: ScriptEditResponse.self, completion: completion)
    }
}
