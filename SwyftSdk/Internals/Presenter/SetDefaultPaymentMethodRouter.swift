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
    
    private func checkFirebaseUser() {
        
        //        // TODO: we should implement an auto retry
        //        guard let _ = Configure.current.session?.sdkFirebaseUser else {
        //            report(.setDefaultPaymentMethodSdkNotInitialized, failure)
        //            return
        //        }

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
