//
//  SwyftSdk.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/9/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
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
        if let _ = Static.instance.session {
            return Static.instance
        } else {
            fatalError("Please initialize the SDK")
        }
    }
    
    class public func setSession(sesssion: SwyftSession) {
        current.session = sesssion
    }
    
    private override init() {}
}


// MARK: Auth
extension Configure {
    
    public static func initSDK() {
        let filePath = Bundle.main.path(forResource: "Swyft-GoogleService-Info", ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
            else { assert(false, "Couldn't load config file")
                return
        }
        let appName = "com_swyft_SwyftSdk"
        FirebaseApp.configure(name: appName, options: fileopts)
        let fbApp = FirebaseApp.app(name: appName)
        initSDK(fbApp: fbApp)
    }
    
    public static func initSDK(fbApp: FirebaseApp?) {
        
        Static.instance._fireBaseApp = fbApp
        Static.instance.session = SwyftSession()
        
        SdkAuthInteractor.auth(success: { response in
            
            current.session?.sdkAuthToken = response.payload.authToken
            current.session?.merchantNames = response.payload.merchantNames
            current.session?.categories = response.payload.categories
            
            if let fbApp = fbApp {
                Static.instance.db = Firestore.firestore(app: fbApp)
                let settings = current.db!.settings
                settings.areTimestampsInSnapshotsEnabled = true
                current.db!.settings = settings
                addAuthentication(authToken: response.payload.authToken, fbApp: fbApp)
            }
            
        }) { error in
            debugPrint(error)
        }
    }
    
    private static func addAuthentication(authToken: String, fbApp: FirebaseApp) {
        
        Auth.auth(app: fbApp).signIn(withCustomToken: authToken) { result, error in
            
            if let _ = error {
                debugPrint("Swyft SDK Auth: Sign In error")
                current.session?.sdkFirebaseUser = nil
            }
            
            if let result = result {
                let user = result.user
                current.session?.sdkFirebaseUser = user
            } else {
                debugPrint("Swyft SDK Auth: No Sign In result info")
                current.session?.sdkFirebaseUser = nil
            }
        }
    }
}


// MARK: Enrollment
extension Configure {
    
    public static func enroll(using info: CustomerInfo, success: @escaping SwyftConstants.enrollCustomerSuccess, failure: SwyftConstants.fail) {
        
        getToken(using: info, success: success, failure: failure)
    }
    
    private static func getToken(using info: CustomerInfo, success: @escaping SwyftConstants.enrollCustomerSuccess, failure: SwyftConstants.fail) {
        
        current.session?.sdkFirebaseUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            
            if let _ = error {
                let error = "Swyft SDK Enroll: Access Token error"
                debugPrint(error)
                failure?(error)
                return
            }
            
            guard let token = token else {
                let error = "Swyft SDK Enroll: No Access Token"
                debugPrint(error)
                failure?(error)
                return
            }
            
            runEnroll(using: token, and: info, success: success, failure: failure)
        })
    }
    
    private static func runEnroll(using idToken: String, and info: CustomerInfo, success: @escaping SwyftConstants.enrollCustomerSuccess, failure: SwyftConstants.fail) {
        
        SdkEnrollInteractor.enroll(customerInfo: info, idToken: idToken, success: { response in
            
            let result = EnrollCustomerResponse(swyftId: response.payload.swyftId)
            success(result)
            
        }) { error in
            failure?(error.debugDescription)
        }
    }
    
    private static func getRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

public struct EnrollCustomerResponse: Codable {
    let swyftId: String
}
