//
//  GenerateScriptService.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire


protocol GenerateScriptServiceProtocol {
    func generateScript(bodyDTO: GenerateScriptRequest, completion: @escaping (NetworkResult<GenerateScriptResponse>) -> Void)
}

final class GenerateScriptService: APIRequestLoader<GenerateScriptTarget>, GenerateScriptServiceProtocol {
    func generateScript(bodyDTO: GenerateScriptRequest, completion: @escaping (NetworkResult<GenerateScriptResponse>) -> Void) {
        fetchData(target: .generateScript(bodyDTO), responseData: GenerateScriptResponse.self, completion: completion)
    }

}
