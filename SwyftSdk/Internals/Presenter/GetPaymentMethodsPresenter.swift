//
//  GetPaymentMethodsPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class GetPaymentMethodsPresenter {
    
    // MARK: Singleton
    static let shared = GetPaymentMethodsPresenter()
    private init() {}
    
    func execute(_ success: @escaping SwyftGetPaymentMethodsCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.getPaymentMethodsSdkNotInitialized, failure)
            return
        }
        
        // TODO implement this
    }
}
