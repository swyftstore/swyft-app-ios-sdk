//
//  RemovePaymentMethodRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class RemovePaymentMethodRouter {
    
    // MARK: Singleton
    static let shared = RemovePaymentMethodRouter()
    private init() {}
    
    // MARK: Data
    var token: String!
    var merchantRef: String!
    var success: SwyftRemovePaymentMethodCallback!
    var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ deleteMethod: SwyftPaymentMethod, _ success: @escaping SwyftRemovePaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        guard let token = deleteMethod.token, let merchantRef = deleteMethod.merchantRef else {
            report(.removePaymentMethodInvalidCardData, failure)
            return;
        }
        // Save all parameters for later use
        self.token = token
        self.merchantRef = merchantRef
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
}

// MARK: Internals
private extension RemovePaymentMethodRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.clientFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.removePaymentMethodSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        removePayment()
    }
    
    private func removePayment() {
        
        let removeMethod = RemovePaymentMethod(cardRef: token, merchantRef: merchantRef)
        
        RemovePaymentInteractor.removePaymentMethod(removeMethod: removeMethod, success: {
            
            let result = SwyftRemovePaymentMethodResponse()
            self.callSuccess(using: result)
            
        }) { error in
            report(.removePaymentMethodFirebaseFailure, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftRemovePaymentMethodResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
