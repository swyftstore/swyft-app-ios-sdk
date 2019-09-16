//
//  SwyftSDK.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseCore

public typealias SwyftEnrollUserCallback = (_ response: SwyftEnrollUserResponse)->()
public typealias SwyftAuthenticateUserCallback = (_ response: SwyftAuthenticateUserResponse)->()
public typealias SwyftAddPaymentMethodCallback = (_ response: SwyftAddPaymentMethodResponse)->()
public typealias SwyftGetPaymentMethodsCallback = (_ response: SwyftGetPaymentMethodsResponse)->()
public typealias SwyftSetDefaultPaymentMethodCallback = (_ response: SwyftSetDefaultPaymentMethodResponse)->()
public typealias SwyftRemovePaymentMethodCallback = (_ response: SwyftRemovePaymentMethodResponse)->()
public typealias SwyftGetOrdersCallback = (_ response: SwyftGetOrdersResponse)->()
public typealias SwyftFailureCallback = (_ error: NSError)->()

public final class SwyftSDK {
    
    private init() {}
    
    public static func initSDK() {
        InitSdkRouter.shared.route()
    }
    
    public static func initSDK(firebaseApp: FirebaseApp?) {
        InitSdkRouter.shared.route(firebaseApp)
    }
    
    public static func enrollUser(user: SwyftUser, success: @escaping SwyftEnrollUserCallback, failure: @escaping SwyftFailureCallback) {
        EnrollUserRouter.shared.route(user, success, failure)
    }
    
    public static func authenticateUser(swyftId: String, qrCodeColor: UIColor, customAuth: String? = nil, success: @escaping SwyftAuthenticateUserCallback, failure: @escaping SwyftFailureCallback) {
        AuthenticateUserRouter.shared.route(swyftId, qrCodeColor, customAuth, success, failure)
    }
    
    public static func addPaymentMethod(method: PaymentMethod, isDefault: Bool, success: @escaping SwyftAddPaymentMethodCallback, failure: @escaping SwyftFailureCallback) {
        AddPaymentMethodRouter.shared.route(method, isDefault, success, failure)
    }
    
    public static func getPaymentMethods(success: @escaping SwyftGetPaymentMethodsCallback, failure: @escaping SwyftFailureCallback) {
        GetPaymentMethodsRouter.shared.route(success, failure)
    }
    
    public static func setDefaultPaymentMethod(defaultMethod: SwyftPaymentMethod, success: @escaping SwyftSetDefaultPaymentMethodCallback, failure: @escaping SwyftFailureCallback) {
        SetDefaultPaymentMethodRouter.shared.route(defaultMethod, success, failure)
    }
    
    public static func removePaymentMethod(cardRef: String, merchantRef: String, success: @escaping SwyftRemovePaymentMethodCallback, failure: @escaping SwyftFailureCallback) {
        RemovePaymentMethodRouter.shared.route(cardRef, merchantRef, success, failure)
    }
    
    public static func getOrders(customerId: String, start: Int, pageSize: Int, success: @escaping SwyftGetOrdersCallback, failure: @escaping SwyftFailureCallback) {
        GetOrdersRouter.shared.route(customerId, start, pageSize, success, failure)
    }
}
