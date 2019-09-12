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
    
    func execute(_ methodId: String, _ success: @escaping SwyftDeleteMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.removePaymentMethodSdkNotInitialized, failure)
            return
        }
        
    }
}
