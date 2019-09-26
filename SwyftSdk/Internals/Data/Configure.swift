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

class Configure: NSObject {
    private var _fireBaseApp: FirebaseApp?
    private var _qrColor = UIColor.black
    
    var db : Firestore?
    var session: SwyftSession?
    
    class var fireBaseApp: FirebaseApp {
        get {
            if let _ = Static.instance._fireBaseApp {
                return Static.instance._fireBaseApp!
            } else {
                fatalError("Please initialize the SDK")
            }
        }
    }
    
    class var qrColor: UIColor {
        set (color) {
            if let _ = Static.instance.session {
                return Static.instance._qrColor = color
            } else {
                fatalError("Please initialize the SDK")
            }
        }
        
        get {
            return Static.instance._qrColor
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
    
    class func setup(firebaseApp: FirebaseApp?) {
        Static.instance.session = SwyftSession()
        Static.instance._fireBaseApp = firebaseApp
    }
    
    class func getFirebaseOptions() -> FirebaseOptions? {
        let env = getEnvironment()
        let swyftOptions = SwyftOptions()
        
        guard let googleAppID = swyftOptions.getOption(env: env, key: SwyftOptions.googleAppIDKey),
        let gcmSenderID = swyftOptions.getOption(env: env, key: SwyftOptions.gcmSenderIDKey),
        let clientID = swyftOptions.getOption(env: env, key: SwyftOptions.clientIDKey),
        let apiKey = swyftOptions.getOption(env: env, key: SwyftOptions.apiKeyKey),
        let projectID = swyftOptions.getOption(env: env, key: SwyftOptions.projectIDKey),
        let bundleID = swyftOptions.getOption(env: env, key: SwyftOptions.bundleIDKey),
        let storageBucket = swyftOptions.getOption(env: env, key: SwyftOptions.storageBucketKey),
        let databaseURL = swyftOptions.getOption(env: env, key: SwyftOptions.databaseURLKey) else {
            print("Invalid FirebaseOptions")
            return nil
        }
        
        let options = FirebaseOptions.init(googleAppID: googleAppID, gcmSenderID: gcmSenderID)
        
        options.clientID = clientID
        options.apiKey = apiKey
        options.projectID = projectID
        options.bundleID = bundleID
        options.storageBucket = storageBucket
        options.databaseURL = databaseURL

        return options;      
    }
    
    class private func getEnvironment() -> String {
        #if DEBUG
            return "dev"
        #else
            return "prod"
        #endif    
    }
    
    private override init() {}
}
