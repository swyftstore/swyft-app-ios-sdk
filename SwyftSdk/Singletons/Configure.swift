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
        if let _ = Static.instance.db {
            return Static.instance
        } else {
            fatalError("Please initialize the SDK")
        }
    }
    
    class public func initSDK() {
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
    
    class public func initSDK(fbApp: FirebaseApp?) {
        
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
            current.session?.merchantNames = response.payload.merchantNames
            current.session?.categories = response.payload.categories
            if let _ = fbApp {
                addAuthentication(authToken: response.payload.authToken, fbApp: fbApp!)
            }
            
        }) { error in
            debugPrint(error)
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
    
    class private func addAuthentication(authToken: String, fbApp: FirebaseApp) {
        Auth.auth(app: fbApp).signIn(withCustomToken: authToken)
        { (result, error) in
            if let _ = error {
                print("Invalid SDK Authentication")
                current.session?.sdkFirebaseUser = nil
            }
            
            if let _ = result {
                let user = result!.user
                current.session?.sdkFirebaseUser = user
            } else {
                 print("Invalid SDK Authentication")
                current.session?.sdkFirebaseUser = nil
            }
            
            
        }
    }
    
    private override init() {
     
    }
}

public struct EnrollCustomerResponse: Codable {
    // TODO: what data should we return?
    let swyftId: String
}
