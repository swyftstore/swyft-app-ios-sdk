//
//  Session.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import FirebaseAuth

open class SwyftSession: NSObject {
    
    var customer : Customer? {
        didSet {
            if let _ = signOnDate {} else {
                signOnDate = Date()
            }
            sessionExpiry = signOnDate?.adding(minutes: SwyftConstants.SessionLength)
        }
    }
    
    var signOnDate: Date?
    var sessionExpiry: Date?
    var signInMethod: String?
    var merchantNames: [String: String]?
    var categories: [String]?
    
    var sdkFirebaseUser: User?
    var sdkAuthToken: String?
    
    var clientFirebaseUser: User?
    
    func isSessionExpired() -> Bool {
        if let _ = signOnDate, let sessionExpiry = sessionExpiry {
            return Date() >= sessionExpiry
        } else {
            return true
        }
    }
    
    func updateSessionExpiry() {
        if !isSessionExpired() {
            sessionExpiry = Date().adding(minutes: SwyftConstants.SessionLength)
        } else {
            debugPrint("Session expired")
        }
    }
}
