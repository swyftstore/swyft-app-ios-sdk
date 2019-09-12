//
//  AddPaymentMethodPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class AddPaymentMethodPresenter {
    
    // MARK: Singleton
    static let shared = AddPaymentMethodPresenter()
    private init() {}
    
    func execute(_ method: SwyftPaymentMethod, _ success: @escaping SwyftAddPaymentCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.addPaymentMethodSdkNotInitialized, failure)
            return
        }
        
    }
}
