//
//  Device.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/22/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class Device: FireStoreModelSerialize, FireStoreModelProto {
    
    @objc public var pushToken: String?
    @objc public var createdOn: String?
    @objc public var userAgent: String?
    @objc public var os: String?
    

    public func toString() {
        //todo
    }
    
}
