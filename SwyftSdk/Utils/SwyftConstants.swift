//
//  Constants.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation

open class SwyftConstants {

    public static let FBSessionStart = "fbSessionStart";
    public static let SessionLength = 10;
    
    //Customer data keys
    public static let ActivationCode = "activationCode"
    public static let PhoneNumber = "phoneNumber"
    public static let Status = "status"
    public static let EmailAddress = "emailAddress"
    public static let LogInCounter = "logInCounter"
    public static let LastLogIn = "lastLogIn"
    
    //Order data keys
    public static let CustomerId = "customerId"
    
    //DB Collections
    public static let CustomerCollection = "customers"
    public static let OrderCollection = "orders"
    public static let ProductCollection = "products"
    
    //Type Alaises
    public typealias readSuccess = ((_ data: FireStoreModelProto)->Void)?
    public typealias readSuccessWArray = ((_ data: [FireStoreModelProto])->Void)?
    public typealias writeSuccess = ((_ msg: String, _ id: String?)->Void)?
    
    public typealias fail = ((_ msg: String)->Void)?
    
    
    
}
