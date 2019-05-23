//
//  SwyftSdk.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/9/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public class Configure: NSObject {
    var db : Firestore?
    var session: SwyftSession? 
    
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
    
    class public func initSDK(db: Firestore) {
        Static.instance.db = db
        
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
