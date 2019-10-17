//
//  Respository.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/7/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Moya

internal enum Repository {
    case auth(token: String)
    case addPayment(paymentMethod: PaymentMethod)
    case editPayment(paymentMethod: EditPaymentMethod)
    case removePayment(paymentMethod: RemovePaymentMethod)
    case sdkAuth(request: SdkAuthRequest)
    case sdkEnroll(request: SdkEnrollRequest)
    case sdkCustomerAuth(request: SdkUserAuthRequest)
}

extension Repository: TargetType {
    
    var baseURL: URL {
        switch self {
        case .auth:
            return  Utils.getBaseURL()!
        case .addPayment:
            return Utils.getPaymentURL()!
        case .editPayment:
            return Utils.getPaymentURL()!
        case .removePayment:
            return Utils.getPaymentURL()!
        case .sdkAuth, .sdkEnroll, .sdkCustomerAuth:
            return  Utils.getBaseURL()!
        }
    }
    
    var path: String {
        switch self {
        case .auth:
            return "rest/auth"
        case .addPayment:
            return "merchant/xmlpayment"
        case .editPayment:
            return "merchant/xmlpayment"
        case .removePayment:
            return "merchant/xmlpayment"
        case .sdkAuth:
            return "rest/sdk_auth"
        case .sdkEnroll:
            return "rest/sdk_enroll"
        case .sdkCustomerAuth:
            return "rest/sdk_customer_auth"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        case .addPayment:
            return .post
        case .editPayment:
            return .post
        case .removePayment:
            return .post
        case .sdkAuth, .sdkEnroll, .sdkCustomerAuth:
            return .post
        }
    }
    
    var parameters: [String : Any] {
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
    
    
    var data: Data {
        switch self {
        case .addPayment(let paymentMethod):
            let req = paymentMethod.toXMLString()
            return req.data(using: .utf8)!
        case .removePayment(let paymentMethod):
            let req = paymentMethod.toXMLString()
            return req.data(using: .utf8)!
        case .editPayment(let paymentMethod):
            let req = paymentMethod.toXMLString()
            return req.data(using: .utf8)!
        default:
            return Data()
        }
    }
        

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .auth:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addPayment:
            return .requestData(data)
        case .removePayment:
            return .requestData(data)
        case .editPayment:
            return .requestData(data)
        case .sdkAuth(let request):
            return .requestJSONEncodable(request)
        case .sdkEnroll(let request):
            return .requestJSONEncodable(request)
        case .sdkCustomerAuth(let request):
            return .requestJSONEncodable(request)
        }
      
    }
    
    var headers: [String : String]? {
        var headers = [String: String]()
        switch self {
        case .auth:            
            headers["Content-Type"] = "application/json"
            return headers
        case .addPayment:
            headers["Content-Type"] = "text/x-markdown"
            return headers
        case .removePayment:
            headers["Content-Type"] = "text/x-markdown"
            return headers
        case .editPayment:
            headers["Content-Type"] = "text/x-markdown"
            return headers
        case .sdkAuth, .sdkEnroll, .sdkCustomerAuth:
            headers["Accept"] = "application/json"
            headers["Content-type"] = "application/json"
            return headers
        }
    }
}
