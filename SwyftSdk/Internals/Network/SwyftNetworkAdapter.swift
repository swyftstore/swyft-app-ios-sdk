//
//  auth.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/7/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Moya


class SwyftNetworkAdapter {
    static var plugins : [PluginType] = []
    //plugins.append(NetworkLoggerPlugin())
    static let provider = MoyaProvider<Repository>(plugins:plugins)
    
    
    static func request(target: Repository, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                // 1:
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    // 2:
                    let error: NSError
                    
                    if let respJson = Utils.getJsonString(from: response),
                        let errorResp: SdkErrorResponse = respJson.decodeFrom()  {
                        error = NSError(domain:"com.swyft.networkLayer", code:0, userInfo:[NSLocalizedDescriptionKey: errorResp.error])
                        
                    } else {
                        error = NSError(domain:"com.swyft.networkLayer", code:0, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    }
                    errorCallback(error)
                }
            case .failure(let error):
                // 3:
                failureCallback(error)
            }
        }
    }
    
    
}
