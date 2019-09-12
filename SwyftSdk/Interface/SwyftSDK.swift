//
//  SwyftSDK.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

public typealias SwyftEnrollCallback = (_ response: SwyftEnrollResponse)->()
public typealias SwyftAuthenticateUserCallback = (_ response: SwyftAuthenticateUserResponse)->()
public typealias SwyftAddPaymentCallback = (_ response: SwyftAddPaymentResponse)->()
public typealias SwyftGetPaymentMethodsCallback = (_ response: SwyftGetPaymentMethodsResponse)->()
public typealias SwyftDefaultMethodCallback = (_ response: SwyftDefaultMethodResponse)->()
public typealias SwyftDeleteMethodCallback = (_ response: SwyftDeleteMethodResponse)->()
public typealias SwyftGetOrdersCallback = (_ response: SwyftGetOrdersResponse)->()
public typealias SwyftFailureCallback = (_ error: SwyftError)->()

public final class SwyftSDK {
    
    private init() {}
    
    public static func initSDK() {}
    
    public static func enrollUser(user: SwyftUser, success: SwyftEnrollCallback, failure: SwyftFailureCallback) {}
    
    public static func authenticateUser(swyftId: String, qrCodeColor: UIColor, customAuth: String? = nil, success: SwyftAuthenticateUserCallback, failure: SwyftFailureCallback) {}
    
    public static func addPaymentMethod(method: SwyftPaymentMethod, success: SwyftAddPaymentCallback, failure: SwyftFailureCallback) {}
    
    public static func getPaymentMethods(success: SwyftGetPaymentMethodsCallback, failure: SwyftFailureCallback) {}
    
    public static func setDefaultPaymentMethod(methodId: String, success: SwyftDefaultMethodCallback, failure: SwyftFailureCallback) {}
    
    public static func removePaymentMethod(methodId: String, success: SwyftDeleteMethodCallback, failure: SwyftFailureCallback) {}
    
    public static func getOrders(start: Int, pageSize: Int, success: SwyftGetOrdersCallback, failure: SwyftFailureCallback) {}
}
