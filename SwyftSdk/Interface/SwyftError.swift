//
//  SwyftError.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

private let baseDomain = "com.swyft.sdk.error"

public enum SwyftError: String, Error {
    
    // MARK: InitSdk
    case initSdkNoSwyftFile
    case initSdkNoFirebaseOptions
    case initSdkFirebaseSignInFailure
    case initSdkNoFirebaseSignIn
    case initSdkAuthFailure
    
    // MARK: EnrollUser
    case enrollUserSdkNotInitialized
    case enrollUserInvalidUserEmail
    case enrollUserInvalidUserFirstName
    case enrollUserInvalidUserLastName
    case enrollUserInvalidUserPhone
    case enrollUserAccessTokenFailure
    case enrollUserNoAccessToken
    case enrollUserSdkEnrollFailure
    
    // MARK: AuthenticateUser
    case authenticateUserSdkNotInitialized
    case authenticateUserSdkCustomerAuthFailure
    case authenticateUserFirebaseSignInFailure
    case authenticateUserNoFirebaseSignIn
    case authenticateUserAccessTokenFailure
    case authenticateUserNoAccessToken
    case authenticateUserQRCodeFailure

    // MARK: AddPaymentMethod
    case addPaymentMethodSdkNotInitialized

    // MARK: GetPaymentMethods
    case getPaymentMethodsSdkNotInitialized

    // MARK: SetDefaultPaymentMethod
    case setDefaultPaymentMethodSdkNotInitialized

    // MARK: RemovePaymentMethod
    case removePaymentMethodSdkNotInitialized

    // MARK: GetOrders
    case getOrdersSdkNotInitialized
}

extension SwyftError {
    
    private func data() -> (code: Int, message: String) {
        
        switch self {
            
        // MARK: InitSdk
        case .initSdkNoSwyftFile:
            return (code: 20_001, message: "")
            
        case .initSdkNoFirebaseOptions:
            return (code: 20_002, message: "")
            
        case .initSdkFirebaseSignInFailure:
            return (code: 20_003, message: "")
            
        case .initSdkNoFirebaseSignIn:
            return (code: 20_004, message: "")
            
        case .initSdkAuthFailure:
            return (code: 20_005, message: "")
            
            
        // MARK: EnrollUser
        case .enrollUserSdkNotInitialized:
            return (code: 20_101, message: "SwyftSdk still initializing, please wait a moment and try again")
            
        case .enrollUserInvalidUserEmail:
            return (code: 20_102, message: "Swyft SDK Enroll: Invalid customer email")
            
        case .enrollUserInvalidUserFirstName:
            return (code: 20_103, message: "Swyft SDK Enroll: Invalid customer first name")
            
        case .enrollUserInvalidUserLastName:
            return (code: 20_104, message: "Swyft SDK Enroll: Invalid customer last name")
            
        case .enrollUserInvalidUserPhone:
            return (code: 20_105, message: "Swyft SDK Enroll: Invalid customer phone number")
            
        case .enrollUserAccessTokenFailure:
            return (code: 20_106, message: "Swyft SDK Enroll: Access Token error")
            
        case .enrollUserNoAccessToken:
            return (code: 20_107, message: "Swyft SDK Enroll: No Access Token")
            
        case .enrollUserSdkEnrollFailure:
            return (code: 20_108, message: "")
            
            
        // MARK: AuthenticateUser
        case .authenticateUserSdkNotInitialized:
            return (code: 20_201, message: "SwyftSdk still initializing, please wait a moment and try again")
            
        case .authenticateUserSdkCustomerAuthFailure:
            return (code: 20_202, message: "")
            
        case .authenticateUserFirebaseSignInFailure:
            return (code: 20_203, message: "Swyft SDK Auth: Sign In error")
            
        case .authenticateUserNoFirebaseSignIn:
            return (code: 20_204, message: "Swyft SDK Auth: No Sign In result info")
            
        case .authenticateUserAccessTokenFailure:
            return (code: 20_205, message: "Swyft SDK Customer Auth: Access Token error")
            
        case .authenticateUserNoAccessToken:
            return (code: 20_206, message: "Swyft SDK Customer Auth: No Access Token")
            
        case .authenticateUserQRCodeFailure:
            return (code: 20_207, message: "QR Code was not generated...")
            
        
        // MARK: AddPaymentMethod
        case .addPaymentMethodSdkNotInitialized:
            return (code: 20_301, message: "")
            
            
        // MARK: GetPaymentMethods
        case .getPaymentMethodsSdkNotInitialized:
            return (code: 20_401, message: "")
            
            
        // MARK: SetDefaultPaymentMethod
        case .setDefaultPaymentMethodSdkNotInitialized:
            return (code: 20_501, message: "")
            
            
        // MARK: RemovePaymentMethod
        case .removePaymentMethodSdkNotInitialized:
            return (code: 20_601, message: "")
            
        
        // MARK: GetOrders
        case .getOrdersSdkNotInitialized:
            return (code: 20_701, message: "")
        }
    }
    
    func build() -> NSError {
        let data = self.data()
        let domain = "\(baseDomain).\(self.rawValue)"
        let info = [NSLocalizedDescriptionKey: data.message]
        
        let error = NSError(domain: domain, code: data.code, userInfo: info)
        return error
    }
}

func report(_ error: SwyftError, _ failureCallback: SwyftFailureCallback? = nil) {
    let errorInfo = error.build()
    debugPrint(errorInfo)
    failureCallback?(errorInfo)
}
