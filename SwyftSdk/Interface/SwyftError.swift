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
    case initSdkNoFirebaseAuth
    case initSdkNoFirebaseResult
    
    // MARK: EnrollUser
    case enrollUserSdkNotInitialized
    case enrollUserInvalidUserEmail
    case enrollUserInvalidUserFirstName
    case enrollUserInvalidUserLastName
    case enrollUserInvalidUserPhone
    case enrollUserAccessTokenFailure
    case enrollUserNoAccessToken
    case enrollUserSdkEnrollFailure
    
//    // MARK: AuthenticateUser
////    case authenticateUser // TODO: temporal
//    case authenticateUserSdkNotInitialized
//
//    // MARK: AddPaymentMethod
////    case addPaymentMethod // TODO: temporal
//    case addPaymentMethodSdkNotInitialized
//
//    // MARK: GetPaymentMethods
////    case getPaymentMethods // TODO: temporal
//    case getPaymentMethodsSdkNotInitialized
//
//    // MARK: SetDefaultPaymentMethod
////    case setDefaultPaymentMethod // TODO: temporal
//    case setDefaultPaymentMethodSdkNotInitialized
//
//    // MARK: RemovePaymentMethod
////    case removePaymentMethod // TODO: temporal
//    case removePaymentMethodSdkNotInitialized
//
//    // MARK: GetOrders
////    case getOrders // TODO: temporal
//    case getOrdersSdkNotInitialized
}

extension SwyftError {
    
    private func data() -> (domain: String, code: Int, message: String) {
        
        let domain = "\(baseDomain).\(self.rawValue)"
        
        switch self {
            
        case .initSdkNoSwyftFile:
            return (domain: domain, code: 1, message: "")
            
        case .initSdkNoFirebaseOptions:
            return (domain: domain, code: 2, message: "")
            
        case .initSdkNoFirebaseAuth:
            return (domain: domain, code: 3, message: "")
            
        case .initSdkNoFirebaseResult:
            return (domain: domain, code: 4, message: "")
            
        case .enrollUserSdkNotInitialized:
            return (domain: domain, code: 5, message: "SwyftSdk still initializing, please wait a moment and try again")
            
        case .enrollUserInvalidUserEmail:
            return (domain: domain, code: 6, message: "Swyft SDK Enroll: Invalid customer email")
            
        case .enrollUserInvalidUserFirstName:
            return (domain: domain, code: 7, message: "Swyft SDK Enroll: Invalid customer first name")
            
        case .enrollUserInvalidUserLastName:
            return (domain: domain, code: 8, message: "Swyft SDK Enroll: Invalid customer last name")
            
        case .enrollUserInvalidUserPhone:
            return (domain: domain, code: 9, message: "Swyft SDK Enroll: Invalid customer phone number")
            
        case .enrollUserAccessTokenFailure:
            return (domain: domain, code: 10, message: "Swyft SDK Enroll: Access Token error")
            
        case .enrollUserNoAccessToken:
            return (domain: domain, code: 11, message: "Swyft SDK Enroll: No Access Token")
            
        case .enrollUserSdkEnrollFailure:
            return (domain: domain, code: 12, message: "")
        }
            
//        case .authenticateUserSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
//
//        case .addPaymentMethodSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
//
//        case .getPaymentMethodsSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
//
//        case .setDefaultPaymentMethodSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
//
//        case .removePaymentMethodSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
//
//        case .getOrdersSdkNotInitialized:
//            return (domain: domain, code: 1, message: "")
    }
    
    func build() -> NSError {
        let data = self.data()
        let info = [NSLocalizedDescriptionKey: data.message]
        
        let error = NSError(domain: data.domain, code: data.code, userInfo: info)
        return error
    }
}
