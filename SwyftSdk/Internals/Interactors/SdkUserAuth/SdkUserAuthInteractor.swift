//
//  SdkCustomerAuthInteractor.swift
//  ActionSheetPicker-3.0
//
//  Created by Rigoberto Saenz Imbacuan on 9/9/19.
//

import Moya

internal class SdkUserAuthInteractor {
    
    private static var success: SwyftConstants.sdkUserAuthSuccess?
    private static var failure: SwyftConstants.fail?
    
    static func userAuth(swyftId: String, idToken: String, customAuth: String? = nil, success successCallback: @escaping SwyftConstants.sdkUserAuthSuccess, failure failureCallback: SwyftConstants.fail) {
        
        DispatchQueue.global(qos: .background).async {
            
            // Cache the callbacks to call them later
            success = successCallback
            failure = failureCallback
            
            guard let key = Utils.getSdkAuthKey() else {
                returnError("Swyft SDK Auth: No SDK Auth key on Client App")
                return
            }
            
            guard let id = Bundle.main.bundleIdentifier else {
                returnError("Swyft SDK User Auth: Missing bundle identifier")
                return
            }
            
            let request = SdkUserAuthRequest(key: key, id: id, swyftId: swyftId, idToken: idToken, customAuth: customAuth)
            let endpoint = Repository.sdkCustomerAuth(request: request)
            
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
            returnError("Swyft SDK User Auth: Invalid status code")
            return
        }
        
        // Convert raw data into a json string
        guard let jsonString = Utils.getJsonString(from: rawResponse) else {
            returnError("Swyft SDK User Auth: Data parsing error")
            return
        }
        
        // Converts the jsonString into a valid Object
        guard let response: SdkCustomerAuthResponse = jsonString.decodeFrom() else {
            returnError("Swyft SDK User Auth: Json parsing error")
            return
        }
        
        guard response.success else {
            returnError("Swyft SDK User Auth: Enroll Failed")
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
    
    private static func returnSuccess(using response: SdkCustomerAuthResponse) {
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
