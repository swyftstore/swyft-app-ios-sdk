//
//  SdkAuthInteractor.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Moya

internal class SdkAuthInteractor {
    
    private static var success: SwyftConstants.sdkAuthSuccess?
    private static var failure: SwyftConstants.fail?
    
    static func auth(success successCallback: @escaping SwyftConstants.sdkAuthSuccess, failure failureCallback: SwyftConstants.fail) {
        
        DispatchQueue.global(qos: .background).async {
            
            // Cache the callbacks to call them later
            success = successCallback
            failure = failureCallback
            
            guard let key = Utils.getSdkAuthKey() else {
                returnError("Swyft SDK Auth: No SDK Auth key on Client App")
                return
            }
            
            guard let id = Bundle.main.bundleIdentifier else {
                returnError("Swyft SDK Auth: Missing bundle identifier")
                return
            }
            
            let request = SdkAuthRequest(key: key, id: id)
            let endpoint = Repository.sdkAuth(request: request)
            
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
            returnError("Swyft SDK Auth: Invalid status code")
            return
        }
        
        // Convert raw data into a json string
        guard let jsonString = Utils.getJsonString(from: rawResponse) else {
            returnError("Swyft SDK Auth: Data parsing error")
            return
        }
        
        // Converts the jsonString into a valid Object
        guard let response: SdkAuthResponse = jsonString.decodeFrom() else {
            returnError("Swyft SDK Auth: Json parsing error")
            return
        }
        
        guard response.success else {
            returnError("Swyft SDK Auth: Auth failed")
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
    
    private static func returnSuccess(using response: SdkAuthResponse) {
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
