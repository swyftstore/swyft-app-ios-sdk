//
//  Constants.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation

internal class SwyftConstants {

    internal static let FBSessionStart = "fbSessionStart";
    internal static let SessionLength = 10;
    
    //Customer data keys
    internal static let ActivationCode = "activationCode"
    internal static let PhoneNumber = "phoneNumber"
    internal static let NewPhoneNumber = "newPhoneNumber"
    internal static let Status = "status"
    internal static let EmailAddress = "emailAddress"
    internal static let LogInCounter = "logInCounter"
    internal static let LastLogIn = "lastLogIn"
    
    //Order data keys
    internal static let CustomerId = "customerId"
    
    //Store data keys
    internal enum StoreSearchKey : String{
        case ID = "id"
        case GeoPoint = "geoPoint"
        case Name = "name"
        case MerchantName = "merchantName"
        
        static let values = [ID.rawValue, GeoPoint.rawValue, Name.rawValue,MerchantName.rawValue]
    }
    
    //DB Collections
    internal static let CustomerCollection = "customers"
    internal static let OrderCollection = "/nanoshop/cart/transactions"
    internal static let ProductCollection = "products"
    internal static let StoreCollection = "stores"
    internal static let OrderCreationDate = "createDateTime"
    
    //DB Retries
    internal static let MaxDbRetries = 10
    internal static let WaitBetweenRetries = 250_000
    
    //Router Retries
    internal static let RouterMaxRetries = 10
    internal static let RouterWaitBetweenRetries = 500_000
    
    //Type Alaises
    internal typealias readSuccess = ((_ data: FireStoreModelProto)->Void)?
    internal typealias readSuccessWArray = ((_ data: [FireStoreModelProto])->Void)?
    internal typealias writeSuccess = ((_ msg: String, _ id: String?)->Void)?
    internal typealias addPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    internal typealias editPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    internal typealias defaultPaymentSuccess = (()->Void)?
    internal typealias removePaymentSuccess = (()->Void)?
    internal typealias sdkAuthSuccess = (_ response: SdkAuthResponse)->Void
    internal typealias sdkEnrollSuccess = (_ response: SdkEnrollResponse)->Void
    internal typealias sdkCustomerAuthSuccess = (_ response: SdkCustomerAuthResponse)->Void
    internal typealias fail = ((_ msg: String)->Void)?
}
