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
    public static let NewPhoneNumber = "newPhoneNumber"
    public static let Status = "status"
    public static let EmailAddress = "emailAddress"
    public static let LogInCounter = "logInCounter"
    public static let LastLogIn = "lastLogIn"
    
    //Order data keys
    public static let CustomerId = "customerId"
    
    //Store data keys
    public enum StoreSearchKey : String{
        case ID = "id"
        case GeoPoint = "geoPoint"
        case Name = "name"
        case MerchantName = "merchantName"
        
        static let values = [ID.rawValue, GeoPoint.rawValue, Name.rawValue,MerchantName.rawValue]
    }
    
    // SDK Auth
    public static let sdkAuthKey = "fasdfg32243tfavartefgfy5h647sdfv2R2"
    public static let sdkAuthId = "com.swyft.SwyftApp"
    
    //DB Collections
    public static let CustomerCollection = "customers"
    public static let OrderCollection = "/nanoshop/cart/transactions"
    public static let ProductCollection = "products"
    public static let StoreCollection = "stores"
    public static let OrderCreationDate = "createDateTime"
    
    //Type Alaises
    public typealias readSuccess = ((_ data: FireStoreModelProto)->Void)?
    public typealias readSuccessWArray = ((_ data: [FireStoreModelProto])->Void)?
    public typealias writeSuccess = ((_ msg: String, _ id: String?)->Void)?
    public typealias addPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    public typealias editPaymentSuccess = ((_ method: SwyftPaymentMethod)->Void)?
    public typealias defaultPaymentSuccess = (()->Void)?
    public typealias removePaymentSuccess = (()->Void)?
    public typealias sdkAuthSuccess = (_ response: SdkAuthResponse)->Void
    public typealias sdkEnrollSuccess = (_ response: SdkEnrollResponse)->Void
    public typealias enrollCustomerSuccess = (_ response: EnrollCustomerResponse)->Void
    public typealias fail = ((_ msg: String)->Void)?
    
    //Errors
    enum ClientError: Error {
        case runtimeError(String)
    }
    
    
    
}
