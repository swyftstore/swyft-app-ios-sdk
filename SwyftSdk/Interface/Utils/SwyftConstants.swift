//
//  Constants.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation

class SwyftConstants {

    static let FBSessionStart = "fbSessionStart";
    static let SessionLength = 10;
    
    //Customer data keys
    static let ActivationCode = "activationCode"
    static let PhoneNumber = "phoneNumber"
    static let NewPhoneNumber = "newPhoneNumber"
    static let Status = "status"
    static let EmailAddress = "emailAddress"
    static let LogInCounter = "logInCounter"
    static let LastLogIn = "lastLogIn"
    
    //Order data keys
    static let CustomerId = "customerId"
    
    //Store data keys
    enum StoreSearchKey : String{
        case ID = "id"
        case GeoPoint = "geoPoint"
        case Name = "name"
        case MerchantName = "merchantName"
        
        static let values = [ID.rawValue, GeoPoint.rawValue, Name.rawValue,MerchantName.rawValue]
    }
    
    //DB Collections
    static let CustomerCollection = "customers"
    static let OrderCollection = "/nanoshop/cart/transactions"
    static let ProductCollection = "products"
    static let StoreCollection = "stores"
    static let OrderCreationDate = "createDateTime"
    
    //DB Retries
    static let MaxDBRetries = 20
    static let WaitBetweenRetries = 250_000
    
    //Router Retries
    static let RouterMaxRetries = 20
    static let RouterWaitBetweenRetries = 250_000
    
    //Type Alaises
    typealias readSuccess = ((_ data: FireStoreModelProto)->Void)?
    typealias readSuccessWArray = ((_ data: [FireStoreModelProto])->Void)?
    typealias writeSuccess = ((_ msg: String, _ id: String?)->Void)?
    typealias addPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    typealias editPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    typealias defaultPaymentSuccess = (()->Void)?
    typealias removePaymentSuccess = (()->Void)?
    typealias sdkAuthSuccess = (_ response: SdkAuthResponse)->Void
    typealias sdkEnrollSuccess = (_ response: SdkEnrollResponse)->Void
    typealias sdkUpdateUserSuccess = (_ response: writeSuccess)->Void
    typealias sdkUserAuthSuccess = (_ response: SdkCustomerAuthResponse)->Void
    typealias fail = ((_ msg: String)->Void)?
}
