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
    
    
    // MARK: AuthenticateUser
    
    
    // MARK: AddPaymentMethod
    
    
    // MARK: GetPaymentMethods
    
    
    // MARK: SetDefaultPaymentMethod
    
    
    // MARK: RemovePaymentMethod
    
    
    // MARK: GetOrders
    
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
        }
    }
    
    func build() -> NSError {
        let data = self.data()
        let info = [NSLocalizedDescriptionKey: data.message]
        
        let error = NSError(domain: data.domain, code: data.code, userInfo: info)
        return error
    }
}
