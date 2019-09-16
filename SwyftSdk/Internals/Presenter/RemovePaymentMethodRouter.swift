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
    var cardRef: String!
    var merchantRef: String!
    var success: SwyftRemovePaymentMethodCallback!
    var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ cardRef: String, _ merchantRef: String, _ success: @escaping SwyftRemovePaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.cardRef = cardRef
        self.merchantRef = merchantRef
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
    
    private func checkFirebaseUser() {
        
        //        // TODO: we should implement an auto retry
        //        guard let _ = Configure.current.session?.sdkFirebaseUser else {
        //            report(.removePaymentMethodSdkNotInitialized, failure)
        //            return
        //        }

        removePayment()
    }
    
    private func removePayment() {
        
        let removeMethod = RemovePaymentMethod(cardRef: cardRef, merchantRef: merchantRef)
        
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
