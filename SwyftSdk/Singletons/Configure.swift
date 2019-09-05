//
//  SwyftSdk.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/9/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

public class Configure: NSObject {
    private var _fireBaseApp: FirebaseApp?
    
    var db : Firestore?
    var session: SwyftSession?
    
    class public var fireBaseApp: FirebaseApp {
        get {
            if let _ = Static.instance._fireBaseApp {
                return Static.instance._fireBaseApp!
            } else {
                fatalError("Please initialize the SDK")
            }
        }
    }
    
    private struct Static {
        static let instance : Configure = Configure()
    }
    
    class var current : Configure {
        if let _ = Static.instance.db {
            return Static.instance
        } else {
            fatalError("Please initialize the SDK")
        }
    }
    
    class public func initSDK(success successCallback: @escaping SwyftConstants.initSDKSuccess, failure failureCallback: SwyftConstants.fail) {
        let filePath = Bundle.main.path(forResource: "Swyft-GoogleService-Info", ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
            else { assert(false, "Couldn't load config file")
                return
        }
        let appName = "com_swyft_SwyftSdk"
        FirebaseApp.configure(name: appName, options: fileopts)
        let fbApp = FirebaseApp.app(name: appName)
        initSDK(fbApp: fbApp, success: successCallback, failure: failureCallback)
    }
    
    class public func initSDK(fbApp: FirebaseApp?, success: @escaping SwyftConstants.initSDKSuccess, failure: SwyftConstants.fail) {
        
        Static.instance._fireBaseApp = fbApp
        if let _ = fbApp {
            Static.instance.db = Firestore.firestore(app: fbApp!)
        }
        
        let settings = current.db!.settings
        settings.areTimestampsInSnapshotsEnabled = true
        current.db!.settings = settings
        current.session = SwyftSession()
        
        SdkAuthInteractor.auth(success: { response in
            
            current.session?.sdkAuthToken = response.payload.authToken
            
            let result = InitSDKResponse(merchantNames: response.payload.merchantNames, categories: response.payload.categories)
            success(result)
            
        }) { error in
            failure?(error.debugDescription)
        }
    }
    
    class public func enrollCustomer(_ customer: Customer, success: @escaping SwyftConstants.enrollCustomerSuccess, failure: SwyftConstants.fail) {
        
        guard let idToken = current.session?.sdkAuthToken else {
            failure?("Swyft SDK Enroll: Auth Token missing")
            return
        }
        
        SdkEnrollInteractor.enroll(customer: customer, idToken: idToken, success: { response in
            
            let result = EnrollCustomerResponse(swyftId: response.payload.swyftId)
            success(result)
            
        }) { error in
            failure?(error.debugDescription)
        }
    }
    
    class public func setSession(sesssion: SwyftSession) {
         current.session = sesssion
    }
    
    private override init() {
     
    }
}

public struct InitSDKResponse {
    let merchantNames: [String: String]
    let categories: [String]
}

public struct EnrollCustomerResponse {
    // TODO: what data should we return?
    let swyftId: String
}
