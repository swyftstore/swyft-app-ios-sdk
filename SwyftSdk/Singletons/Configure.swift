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
    
    class public func initSDK(fbApp: FirebaseApp?) {
       
        Static.instance._fireBaseApp = fbApp
        Static.instance.db = Firestore.firestore()
        
        let settings = current.db!.settings
        settings.areTimestampsInSnapshotsEnabled = true
        current.db!.settings = settings
        current.session = SwyftSession()
    }
    
    class public func setSession(sesssion: SwyftSession) {
         current.session = sesssion
    }
    
    
    
    private override init() {
     
    }
    
}
