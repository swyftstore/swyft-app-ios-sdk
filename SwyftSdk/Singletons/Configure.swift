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
        
        guard let id = Bundle.main.bundleIdentifier else {
            failure?("initSDK: Bundle Id failure")
            return
        }
        
        let key = "" // TODO fill in this
        
        SdkAuthInteractor.auth(key: key, id: id, success: { response in
            
            guard response.success else {
                failure?("initSDK: SDK Auth failure")
                return
            }
            
            current.session?.sdkAuthToken = response.payload.authToken
            
            let result = InitSDKResponse(merchantNames: response.payload.merchantNames, categories: response.payload.categories)
            success(result)
            
        }) { error in
            failure?(error.debugDescription)
        }
    }
    
    class public func enrollCustomer(_ customer: Customer, success: @escaping SwyftConstants.enrollCustomerSuccess, failure: SwyftConstants.fail) {
        
        let key = "" // TODO fill in this
        
        guard let id = Bundle.main.bundleIdentifier else {
            failure?("initSDK: Bundle Id failure")
            return
        }
        
        guard let idToken = current.session?.sdkAuthToken else {
            failure?("enrollCustomer: SDK Auth Token missing")
            return
        }
        
        guard let emailAddress = customer.emailAddress,
              let firstName = customer.firstName,
              let lastName = customer.lastName,
              let phoneNumber = customer.phoneNumber else {
                
            failure?("enrollCustomer: Customer data missing")
            return
        }
        
        SdkEnrollInteractor.enroll(key: key, id: id, idToken: idToken, emailAddress: emailAddress, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, success: { response in
            
            guard response.success else {
                failure?("initSDK: SDK Enroll failure")
                return
            }
            
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
    // TODO: what data should be return?
    let swyftId: String
}
