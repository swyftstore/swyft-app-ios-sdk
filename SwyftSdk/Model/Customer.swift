//
//  Customer.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/2/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation


public class Customer: FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var firstName: String?
    @objc public var lastName: String?
    @objc public var phoneNumber: String?
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
    
    public func toString() {
        //write to string for logging
    }      
}
