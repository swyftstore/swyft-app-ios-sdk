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
    
    public static func authenticateUser(swyftId: String, qrCodeColor: UIColor, customAuth: String? = nil, success: @escaping SwyftAuthenticateUserCallback, failure: @escaping SwyftFailureCallback) {
        AuthenticateUserPresenter.shared.execute(swyftId, qrCodeColor, customAuth, success, failure)
    }
    
    public static func addPaymentMethod(method: SwyftPaymentMethod, success: @escaping SwyftAddPaymentCallback, failure: @escaping SwyftFailureCallback) {
        AddPaymentMethodPresenter.shared.execute(method, success, failure)
    }
    
    public static func getPaymentMethods(success: @escaping SwyftGetPaymentMethodsCallback, failure: @escaping SwyftFailureCallback) {
        GetPaymentMethodsPresenter.shared.execute(success, failure)
    }
    
    public static func setDefaultPaymentMethod(methodId: String, success: @escaping SwyftDefaultMethodCallback, failure: @escaping SwyftFailureCallback) {
        SetDefaultPaymentMethodPresenter.shared.execute(methodId, success, failure)
    }
    
    public static func removePaymentMethod(methodId: String, success: @escaping SwyftDeleteMethodCallback, failure: @escaping SwyftFailureCallback) {
        RemovePaymentMethodPresenter.shared.execute(methodId, success, failure)
    }
    
    public static func getOrders(customerId: String, start: Int, pageSize: Int, success: @escaping SwyftGetOrdersCallback, failure: @escaping SwyftFailureCallback) {
        GetOrdersPresenter.shared.execute(customerId, start, pageSize, success, failure)
    }
}
