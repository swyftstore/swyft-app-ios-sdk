//
//  AddPaymentMethodRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class AddPaymentMethodRouter {
    
    // MARK: Singleton
    static let shared = AddPaymentMethodRouter()
    private init() {}
    
    // MARK: Data
    private var method: PaymentMethod!
    private var isDefault: Bool!
    private var success: SwyftAddPaymentMethodCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ method: PaymentMethod, _ isDefault: Bool, _ success: @escaping SwyftAddPaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.method = method
        self.isDefault = isDefault
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
}

// MARK: Internals
private extension AddPaymentMethodRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.addPaymentMethodSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        addMethod()
    }
    
    private func addMethod() {
        
        AddPaymentInteractor.addPaymentMethod(method: method, isDefault: isDefault, success: { paymentMethod in
            
            let result = SwyftAddPaymentMethodResponse(paymentMethod: paymentMethod)
            self.callSuccess(using: result)
            
        }) { error in
            report(.AddPaymentMethodFirebaseFailure, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftAddPaymentMethodResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
