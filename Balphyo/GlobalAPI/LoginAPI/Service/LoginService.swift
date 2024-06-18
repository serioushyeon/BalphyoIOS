//
//  LoginService.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire


protocol LoginServiceProtocol {
    func generateUid(completion: @escaping (NetworkResult<GenerateUidResponse>) -> Void)
    func verifyUid(completion: @escaping (NetworkResult<VerifyUidResponse>) -> Void)
}

final class LoginService: APIRequestLoader<LoginTarget>, LoginServiceProtocol {
    
    func generateUid(completion: @escaping (NetworkResult<GenerateUidResponse>) -> Void) {
        fetchData(target: .generateUid, responseData: GenerateUidResponse.self, completion: completion)
    }
    
    func verifyUid(completion: @escaping (NetworkResult<VerifyUidResponse>) -> Void) {
        fetchData(target: .verifyUid, responseData: VerifyUidResponse.self, completion: completion)
    }
}
