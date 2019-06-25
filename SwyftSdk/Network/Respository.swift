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
    case addPayment(paymentMethod: PaymentMethod)
}

extension Repository: TargetType {
    public var baseURL: URL {
        switch self {
        case .auth:
            return  Utils.getBaseURL()!
        case .addPayment:
            return Utils.getPyamentURL()!
        }
    }
    
    public var path: String {
        switch self {
        case .auth:
            return "rest/auth"
        case .addPayment:
            return "merchant/xmlpayment"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        case .addPayment:
            return .post
        }
    }
    
    public var parameters: [String : Any] {
        switch self {
        case .auth(let token):
            var parameters = [String: Any]()
            parameters["token"] = token
            return parameters
        default:
            let parameters = [String: Any]()
            return parameters
        }
    }
    
    
    public var data: Data {
        switch self {
        case .addPayment(let paymentMethod):
            return "\"\(paymentMethod)\"".data(using: .utf8)!
        default:
            return Data()
        }
    }
    

    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .auth:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addPayment:
            return .requestData(data)
        }
      
    }
    
    public var headers: [String : String]? {
        var headers = [String: String]()
        switch self {
        case .auth:            
            headers["Content-Type"] = "application/json"
            return headers
        default:
            return headers
        }
        
    }
    
    
}


