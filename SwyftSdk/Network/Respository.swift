//
//  Respository.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/7/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Moya

public enum Repository {
    case auth(token: String)
}

extension Repository: TargetType {
    public var baseURL: URL { return Utils.getBaseURL()! }
    
    public var path: String {
        switch self {
        case .auth:
            return "rest/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        }
    }
    
    public var parameters: [String: Any] {
        switch self {
        case .auth(let token):
            var parameters = [String: Any]()
            parameters["token"] = token
            return parameters        
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .auth:
              return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
      
    }
    
    public var headers: [String : String]? {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    
}


