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
    
    class func setup(session: SwyftSession, firebaseApp: FirebaseApp?) {
        current.session = session
        Static.instance._fireBaseApp = firebaseApp
    }
    
    private override init() {}
}
