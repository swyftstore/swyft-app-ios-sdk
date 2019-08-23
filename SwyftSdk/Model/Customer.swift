//
//  Customer.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/2/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SwiftTryCatch
import FirebaseFirestore


public class Customer: FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var firstName: String?
    @objc public var lastName: String?
    @objc public var phoneNumber: String?
    @objc public var newPhoneNumber: String?
    @objc public var logInCounter = 0
    @objc public var lastLogIn: String?
    @objc public var birthDate: String?
    @objc public var createdOn: String?
    @objc public var emailAddress: String?
    @objc public var signInMethod: String?
    @objc public var status: String?
    @objc public var activationCode: String?
    @objc public var accountType = "customer"
    @objc public var notifications: Notifications?
    @objc public var defaultPaymentMethod: String?
    @objc public var paymentMethods:  [String: SwyftPaymentMethod] = [:]
    @objc public var devices: [Device] = []
    @objc public var userAgent: String?
    @objc public var lastKnownLocation: GeoPoint?
    
    public func toString() {
        //write to string for logging
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            SwiftTryCatch.try({
                let keyName = key as String
                if self.responds(to: Selector(keyName)) {
                    if "paymentMethods" == keyName,
                        let values = value as? Dictionary<String, Dictionary<String, Any>> {
                        var paymentMethods = [String: SwyftPaymentMethod]()
                        for (_key, val) in values {
                            let paymentMethod = SwyftPaymentMethod()
                            paymentMethod.serialize(data: val)
                            paymentMethods[_key] = paymentMethod
                        }
                        self.setValue(paymentMethods, forKey: keyName)
                    } else if "devices" == keyName, let values = value as? Array<Dictionary<String, Any>> {
                        
                        var devices = [Device]()
                        for (val) in values {
                            let device = Device()
                            device.serialize(data: val)
                            devices.append(device)
                        }
                        self.setValue(devices, forKey: keyName)
                        
                    } else {
                        self.setValue(value, forKey: keyName)
                    }
                }
            }, catch: { (error) in
                print("Error serializing data \(error!.description)")
            }, finally: {})
        }
    }
}
