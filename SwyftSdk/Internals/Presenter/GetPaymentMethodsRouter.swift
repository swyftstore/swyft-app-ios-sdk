//
//  GetPaymentMethodsRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class GetPaymentMethodsRouter {
    
    // MARK: Singleton
    static let shared = GetPaymentMethodsRouter()
    private init() {}
    
    // MARK: Data
    private var success: SwyftGetPaymentMethodsCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ success: @escaping SwyftGetPaymentMethodsCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
    
    private func checkFirebaseUser() {
        
        //        // TODO: we should implement an auto retry
        //        guard let _ = Configure.current.session?.sdkFirebaseUser else {
        //            report(.getPaymentMethodsSdkNotInitialized, failure)
        //            return
        //        }

        getMethods()
    }
    
    private func getMethods() {
        
        // TODO implement this!!!
    }
    
    private func callSuccess(using response: SwyftGetPaymentMethodsResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
