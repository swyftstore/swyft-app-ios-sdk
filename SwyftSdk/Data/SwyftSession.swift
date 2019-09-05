//
//  Session.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation


open class SwyftSession: NSObject {
    
    public var customer : Customer? {
        didSet {
            if let _ = signOnDate {} else {
                signOnDate = Date()
            }
            sessionExpiry = signOnDate?.adding(minutes: SwyftConstants.SessionLength)
        }
    }
    
    public var signOnDate: Date?
    public var sessionExpiry: Date?
    public var signInMethod: String?
    public var sdkAuthToken: String?
    
   
    
    public func isSessionExpired() -> Bool {
        if let _ = signOnDate, let sessionExpiry = sessionExpiry {
            return Date() >= sessionExpiry
        } else {
            return true
        }
    }
    
    public func updateSessionExpiry() {
        if !isSessionExpired() {
            sessionExpiry = Date().adding(minutes: SwyftConstants.SessionLength)
        } else {
            debugPrint("Session expired")
        }
    }
        
}



