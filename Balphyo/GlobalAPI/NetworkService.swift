//
//  NetwokService.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    let loginService : LoginServiceProtocol = LoginService( apiLogger: APIEventLogger())
    let generateScriptService : GenerateScriptServiceProtocol = GenerateScriptService( apiLogger: APIEventLogger())
    let scriptCrudService : ScriptCrudServiceProtocol = ScriptCrudService( apiLogger: APIEventLogger())
    
    private var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        return Session(configuration: configuration, eventMonitors: [APIEventLogger()])
    }()
    
    /*func setAuthorizationHeader(token: String) {
        sessionManager.sessionConfiguration.headers.add(name: "Authorization", value: "Bearer \(token)")
    }*/
    
}
