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
    
    private static var success: SwyftConstants.initSDKSuccess?
    private static var failure: SwyftConstants.fail?
    
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
    
    class public func initSDK(fbApp: FirebaseApp?, success successCallback: @escaping SwyftConstants.initSDKSuccess, failure failureCallback: SwyftConstants.fail) {
        
        Static.instance._fireBaseApp = fbApp
        if let _ = fbApp {
            Static.instance.db = Firestore.firestore(app: fbApp!)
        }
        
        let settings = current.db!.settings
        settings.areTimestampsInSnapshotsEnabled = true
        current.db!.settings = settings
        current.session = SwyftSession()
        
        // Cache the callbacks to call them later
        success = successCallback
        failure = failureCallback
        
        let key = "" // TODO find out
        let id = "" // TODO find out
        callSdkAuth(key: key, id: id)
    }
    
    private class func callSdkAuth(key: String, id: String) {
        SdkAuthInteractor.auth(key: key, id: id,
        success: { response in
            
            let idToken = "" // TODO find out
            let emailAddress = "" // TODO find out
            let firstName = "" // TODO find out
            let lastName = "" // TODO find out
            let phoneNumber = "" // TODO find out
            callSdkEnroll(key: key, id: id, idToken: idToken, emailAddress: emailAddress, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            
        }) { error in
            failure??(error.debugDescription)
        }
    }
    
    private class func callSdkEnroll(key: String, id: String, idToken: String, emailAddress: String, firstName: String, lastName: String, phoneNumber: String) {
        SdkEnrollInteractor.enroll(key: key, id: id, idToken: idToken, emailAddress: emailAddress, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber,
        success: { response in
            
            success?()
            
        }) { error in
            failure??(error.debugDescription)
        }
    }
    
    class public func setSession(sesssion: SwyftSession) {
         current.session = sesssion
    }
    
    private override init() {
     
    }
}
