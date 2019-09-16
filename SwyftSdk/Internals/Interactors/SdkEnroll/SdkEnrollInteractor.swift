//
//  SdkEnrollInteractor.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Moya

class SdkEnrollInteractor {
    
    private static var success: SwyftConstants.sdkEnrollSuccess?
    private static var failure: SwyftConstants.fail?
    
    static func enroll(customerInfo info: SwyftUser, idToken: String, success successCallback: @escaping SwyftConstants.sdkEnrollSuccess, failure failureCallback: SwyftConstants.fail) {
        
        DispatchQueue.global(qos: .background).async {
            
            // Cache the callbacks to call them later
            success = successCallback
            failure = failureCallback
            
            guard let key = Utils.getSdkAuthKey() else {
                returnError("Swyft SDK Auth: No SDK Auth key on Client App")
                return
            }
            
            guard let id = Bundle.main.bundleIdentifier else {
                returnError("Swyft SDK Enroll: Missing bundle identifier")
                return
            }
            
            let customer = SdkEnrollCustomerRequest(
                emailAddress: info.email,
                firstName: info.firstName,
                lastName: info.lastName,
                phoneNumber: info.phoneNumber)
            
            let request = SdkEnrollRequest(key: key, id: id, idToken: idToken, customer: customer)
            let endpoint = Repository.sdkEnroll(request: request)
            
            SwyftNetworkAdapter.request(
                target: endpoint,
                success: requestSuccess,
                error: requestError,
                failure: requestFailure)
        }
    }
    
    private static func requestSuccess(_ rawResponse: Response) {
        
        let code = rawResponse.statusCode
        
        // HTTP status code validation
        guard code == 200 else {
            returnError("Swyft SDK Enroll: Invalid status code")
            return
        }
        
        // Convert raw data into a json string
        guard let jsonString = Utils.getJsonString(from: rawResponse) else {
            returnError("Swyft SDK Enroll: Data parsing error")
            return
        }
        
        // Converts the jsonString into a valid Object
        guard let response: SdkEnrollResponse = jsonString.decodeFrom() else {
            returnError("Swyft SDK Enroll: Json parsing error")
            return
        }
        
        guard response.success else {
            returnError("Swyft SDK Enroll: Enroll Failed")
            return
        }
        
        // Returns the parsed object
        returnSuccess(using: response)
    }
    
    private static func requestError(_ error: Error) {
        returnError(error.localizedDescription)
    }
    
    private static func requestFailure(_ moyaError: MoyaError) {
        returnError(moyaError.localizedDescription)
    }
    
    private static func returnSuccess(using response: SdkEnrollResponse) {
        DispatchQueue.main.async {
            debugPrint(response)
            success?(response)
        }
    }
    
    private static func returnError(_ msg: String) {
        DispatchQueue.main.async {
            debugPrint(msg)
            failure??(msg)
        }
    }
}
