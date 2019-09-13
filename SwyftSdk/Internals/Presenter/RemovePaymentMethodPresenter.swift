//
//  RemovePaymentMethodPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class RemovePaymentMethodPresenter {
    
    // MARK: Singleton
    static let shared = RemovePaymentMethodPresenter()
    private init() {}
    
    func execute(_ cardRef: String, _ merchantRef: String, _ success: @escaping SwyftRemovePaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.removePaymentMethodSdkNotInitialized, failure)
            return
        }
        
        let removeMethod = RemovePaymentMethod(cardRef: cardRef, merchantRef: merchantRef)
        
        RemovePaymentInteractor.removePaymentMethod(removeMethod: removeMethod, success: {
            
            let response = SwyftRemovePaymentMethodResponse()
            success(response)
            
        }) { error in
            report(.removePaymentMethodFirebaseFailure, failure)
        }
    }
}
