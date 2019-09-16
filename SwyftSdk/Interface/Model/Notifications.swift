//
//  Notifications.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class Notifications: FireStoreModelSerialize, FireStoreModelProto {
    
    @objc public var push = true
    @objc public var email = true
    @objc public var sms = true
    
    public func toString() {
        //todo
    }
}
