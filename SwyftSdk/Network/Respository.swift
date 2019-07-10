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
    case editPayment(paymentMethod: EditPaymentMethod)
    case removePayment(paymentMethod: RemovePaymentMethod)
}

extension Repository: TargetType {
    public var baseURL: URL {
        switch self {
        case .auth:
            return  Utils.getBaseURL()!
        case .addPayment:
            return Utils.getPyamentURL()!
        case .editPayment:
            return Utils.getPyamentURL()!
        case .removePayment:
            return Utils.getPyamentURL()!
        }
    }
    
    public var path: String {
        switch self {
        case .auth:
            return "rest/auth"
        case .addPayment:
            return "merchant/xmlpayment"
        case .editPayment:
            return "merchant/xmlpayment"
        case .removePayment:
            return "merchant/xmlpayment"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        case .addPayment:
            return .post
        case .editPayment:
            return .post
        case .removePayment:
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
            let req = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\(paymentMethod.toXMLString()!)"
            return req.data(using: .utf8)!
        case .removePayment(let paymentMethod):
            let req = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\(paymentMethod.toXMLString()!)"
            return req.data(using: .utf8)!
        case .editPayment(let paymentMethod):
            let req = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\(paymentMethod.toXMLString()!)"
            return req.data(using: .utf8)!
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
        case .removePayment:
            return .requestData(data)
        case .editPayment:
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


