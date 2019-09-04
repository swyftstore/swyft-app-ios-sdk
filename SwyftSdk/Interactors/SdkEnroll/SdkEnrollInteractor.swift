//
//  SdkEnrollInteractor.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Moya

public class SdkEnrollInteractor {
    
    private static var success: SwyftConstants.sdkEnrollSuccess?
    private static var failure: SwyftConstants.fail?
    
    public static func enroll(key: String, id: String, idToken: String, emailAddress: String, firstName: String, lastName: String,
                              phoneNumber: String, success successCallback: @escaping SwyftConstants.sdkEnrollSuccess, failure failureCallback: SwyftConstants.fail) {
        
        DispatchQueue.global(qos: .background).async {
            
            // Cache the callbacks to call them later
            success = successCallback
            failure = failureCallback
            
            // Checks parameters
            guard key.count > 0, id.count > 0, idToken.count > 0, emailAddress.count > 0,
                  firstName.count > 0, lastName.count > 0, phoneNumber.count > 0 else {
                returnError("SDK Enroll: Invalid parameters")
                return
            }
            
            let customer = SdkEnrollCustomerRequest(
                emailAddress: emailAddress,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber)
            
            let request = SdkEnrollRequest(
                key: key,
                id: id,
                idToken: idToken,
                customer: customer)
            
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
            returnError("SDK Enroll: Invalid status code")
            return
        }
        
        // Convert raw data into a json string
        guard let jsonString = ApiUtils.getJsonString(from: rawResponse) else {
            returnError("SDK Enroll: Data parsing error")
            return
        }
        
        // Converts the jsonString into a valid Object
        guard let response: SdkEnrollResponse = jsonString.decodeFrom() else {
            returnError("SDK Enroll: Json parsing error")
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
