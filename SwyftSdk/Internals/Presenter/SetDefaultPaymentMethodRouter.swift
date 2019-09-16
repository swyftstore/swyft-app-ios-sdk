//
//  SetDefaultPaymentMethodRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class SetDefaultPaymentMethodRouter {
    
    // MARK: Singleton
    static let shared = SetDefaultPaymentMethodRouter()
    private init() {}
    
    // MARK: Data
    private var defaultMethod: SwyftPaymentMethod!
    private var success: SwyftSetDefaultPaymentMethodCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ defaultMethod: SwyftPaymentMethod, _ success: @escaping SwyftSetDefaultPaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.defaultMethod = defaultMethod
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
}

// MARK: Internals
private extension SetDefaultPaymentMethodRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.setDefaultPaymentMethodSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        setAsDefault()
    }
    
    private func setAsDefault() {
        
        DefaultPaymentInteractor.setDefaultPaymentMethod(defaultMethod: defaultMethod, success: {
            
            let result = SwyftSetDefaultPaymentMethodResponse()
            self.callSuccess(using: result)
            
        }) { error in
            report(.setDefaultPaymentMethodFirebaseFailure, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftSetDefaultPaymentMethodResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
