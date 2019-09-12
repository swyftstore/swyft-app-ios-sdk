//
//  SwyftSDK.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseCore

public typealias SwyftEnrollCallback = (_ response: SwyftEnrollResponse)->()
public typealias SwyftAuthenticateUserCallback = (_ response: SwyftAuthenticateUserResponse)->()
public typealias SwyftAddPaymentCallback = (_ response: SwyftAddPaymentResponse)->()
public typealias SwyftGetPaymentMethodsCallback = (_ response: SwyftGetPaymentMethodsResponse)->()
public typealias SwyftDefaultMethodCallback = (_ response: SwyftDefaultMethodResponse)->()
public typealias SwyftDeleteMethodCallback = (_ response: SwyftDeleteMethodResponse)->()
public typealias SwyftGetOrdersCallback = (_ response: SwyftGetOrdersResponse)->()
public typealias SwyftFailureCallback = (_ error: NSError)->()

public final class SwyftSDK {
    
    private init() {}
    
    public static func initSDK() {
        InitSdkPresenter.shared.execute()
    }
    
    public static func initSDK(firebaseApp: FirebaseApp?) {
        InitSdkPresenter.shared.execute(firebaseApp)
    }
    
    public static func enrollUser(user: SwyftUser, success: @escaping SwyftEnrollCallback, failure: @escaping SwyftFailureCallback) {
        EnrollUserPresenter.shared.execute(user, success, failure)
    }
    
    public static func authenticateUser(swyftId: String, qrCodeColor: UIColor, customAuth: String? = nil, success: SwyftAuthenticateUserCallback, failure: SwyftFailureCallback) {
        AuthenticateUserPresenter.shared.execute(swyftId, qrCodeColor, customAuth, success, failure)
    }
    
    public static func addPaymentMethod(method: SwyftPaymentMethod, success: SwyftAddPaymentCallback, failure: SwyftFailureCallback) {
        AddPaymentMethodPresenter.shared.execute(method, success, failure)
    }
    
    public static func getPaymentMethods(success: SwyftGetPaymentMethodsCallback, failure: SwyftFailureCallback) {
        GetPaymentMethodsPresenter.shared.execute(success, failure)
    }
    
    public static func setDefaultPaymentMethod(methodId: String, success: SwyftDefaultMethodCallback, failure: SwyftFailureCallback) {
        SetDefaultPaymentMethodPresenter.shared.execute(methodId, success, failure)
    }
    
    public static func removePaymentMethod(methodId: String, success: SwyftDeleteMethodCallback, failure: SwyftFailureCallback) {
        RemovePaymentMethodPresenter.shared.execute(methodId, success, failure)
    }
    
    public static func getOrders(start: Int, pageSize: Int, success: SwyftGetOrdersCallback, failure: SwyftFailureCallback) {
        GetOrdersPresenter.shared.execute(start, pageSize, success, failure)
    }
}
