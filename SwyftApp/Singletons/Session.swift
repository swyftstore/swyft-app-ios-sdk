//
//  Session.swift
//  customer
//
//  Created by Tom Manuel on 5/9/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import SwyftSdk
import FirebaseAuth

class Session: SwyftSession {
    
    var fbSession: AuthDataResult?
    private struct Static {
         static var instance : Session?
    }
    
    class var currentSession : Session  {
        
        if let _ = Static.instance {} else {
            Static.instance = Session()
        }
        
        return Static.instance!
    }
    
    private override init(){
        super.init()
    }
    
    static func signOut() {
        Session.Static.instance = nil
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        (UIApplication.shared.delegate as! AppDelegate).logout()
    }
    
    
}
