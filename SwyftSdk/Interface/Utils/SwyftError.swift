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
    case AddPaymentMethodFirebaseFailure

    // MARK: GetPaymentMethods
    case getPaymentMethodsSdkNotInitialized
    case getPaymentMethodsParsingFailure
    case getPaymentMethodsFirebaseFailure

    // MARK: SetDefaultPaymentMethod
    case setDefaultPaymentMethodSdkNotInitialized
    case setDefaultPaymentMethodFirebaseFailure

    // MARK: RemovePaymentMethod
    case removePaymentMethodSdkNotInitialized
    case removePaymentMethodFirebaseFailure

    // MARK: GetOrders
    case getOrdersSdkNotInitialized
    case getOrdersParsingFailure
    case getOrdersFirebaseFailure
}

private extension SwyftError {
    
    private func data() -> (code: Int, message: String) {
        
        switch self {
            
        // MARK: InitSdk
        case .initSdkNoSwyftFile:
            return (code: 20_001, message: "Swyft SDK init: GoogleService file missing")
            
        case .initSdkNoFirebaseOptions:
            return (code: 20_002, message: "Swyft SDK init: Invalid GoogleService file")
            
        case .initSdkFirebaseSignInFailure:
            return (code: 20_003, message: "Swyft SDK init: Authentication Error")
            
        case .initSdkNoFirebaseSignIn:
            return (code: 20_004, message: "Swyft SDK init: Invalid Firebase SignIn Response")
            
        case .initSdkAuthFailure:
            return (code: 20_005, message: "Swyft SDK init: Authentication Error")
            
            
        // MARK: EnrollUser
        case .enrollUserSdkNotInitialized:
            return (code: 20_101, message: "Swyft SDK Enroll User: SDK still initializing, please wait a moment and try again")
            
        case .enrollUserInvalidUserEmail:
            return (code: 20_102, message: "Swyft SDK Enroll User: Invalid customer email")
            
        case .enrollUserInvalidUserFirstName:
            return (code: 20_103, message: "Swyft SDK Enroll User: Invalid customer first name")
            
        case .enrollUserInvalidUserLastName:
            return (code: 20_104, message: "Swyft SDK Enroll User: Invalid customer last name")
            
        case .enrollUserInvalidUserPhone:
            return (code: 20_105, message: "Swyft SDK Enroll User: Invalid customer phone number")
            
        case .enrollUserAccessTokenFailure:
            return (code: 20_106, message: "Swyft SDK Enroll User: Access Token error")
            
        case .enrollUserNoAccessToken:
            return (code: 20_107, message: "Swyft SDK Enroll User: No Access Token")
            
        case .enrollUserSdkEnrollFailure:
            return (code: 20_108, message: "Swyft SDK Enroll User: Enrollment Failure")
            
            
        // MARK: AuthenticateUser
        case .authenticateUserSdkNotInitialized:
            return (code: 20_201, message: "Swyft SDK Authenticate User: SDK still initializing, please wait a moment and try again")
            
        case .authenticateUserSdkCustomerAuthFailure:
            return (code: 20_202, message: "Swyft SDK Authenticate User: Authenticacion Failure")
            
        case .authenticateUserFirebaseSignInFailure:
            return (code: 20_203, message: "Swyft SDK Authenticate User: Sign In error")
            
        case .authenticateUserNoFirebaseSignIn:
            return (code: 20_204, message: "Swyft SDK Authenticate User: No Sign In result info")
            
        case .authenticateUserAccessTokenFailure:
            return (code: 20_205, message: "Swyft SDK Authenticate User: Access Token error")
            
        case .authenticateUserNoAccessToken:
            return (code: 20_206, message: "Swyft SDK Authenticate User: No Access Token")
            
        case .authenticateUserQRCodeFailure:
            return (code: 20_207, message: "Swyft SDK Authenticate User: QR Code was not generated")
            
        
        // MARK: AddPaymentMethod
        case .addPaymentMethodSdkNotInitialized:
            return (code: 20_301, message: "Swyft SDK Add Payment Method: SDK still initializing, please wait a moment and try again")
            
        case .AddPaymentMethodFirebaseFailure:
            return (code: 20_302, message: "Swyft SDK Add Payment Method: Firebase Error")
            
            
        // MARK: GetPaymentMethods
        case .getPaymentMethodsSdkNotInitialized:
            return (code: 20_401, message: "Swyft SDK Get Payment Methods: SDK still initializing, please wait a moment and try again")
            
        case .getPaymentMethodsParsingFailure:
            return (code: 20_402, message: "Swyft SDK Get Payment Methods: Invalid Data Format")
            
        case .getPaymentMethodsFirebaseFailure:
            return (code: 20_403, message: "Swyft SDK Get Payment Methods: Firebase Error")
            
            
        // MARK: SetDefaultPaymentMethod
        case .setDefaultPaymentMethodSdkNotInitialized:
            return (code: 20_501, message: "Swyft SDK Set Default Payment Method: SDK still initializing, please wait a moment and try again")
            
        case .setDefaultPaymentMethodFirebaseFailure:
            return (code: 20_502, message: "Swyft SDK Set Default Payment Method: Firebase Error")
            
            
        // MARK: RemovePaymentMethod
        case .removePaymentMethodSdkNotInitialized:
            return (code: 20_601, message: "Swyft SDK Remove Payment Method: SDK still initializing, please wait a moment and try again")
            
        case .removePaymentMethodFirebaseFailure:
            return (code: 20_602, message: "Swyft SDK Remove Payment Method: Firebase Error")
            
        
        // MARK: GetOrders
        case .getOrdersSdkNotInitialized:
            return (code: 20_701, message: "Swyft SDK Get Orders: SDK still initializing, please wait a moment and try again")
            
        case .getOrdersParsingFailure:
            return (code: 20_702, message: "Swyft SDK Get Orders: Invalid Data Format")
            
        case .getOrdersFirebaseFailure:
            return (code: 20_703, message: "Swyft SDK Get Orders: Firebase Error")
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
    DispatchQueue.main.async {
        let errorInfo = error.build()
        debugPrint(errorInfo)
        failureCallback?(errorInfo)
    }
}
