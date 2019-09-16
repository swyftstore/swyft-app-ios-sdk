//
//  AddPaymentMethodRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class AddPaymentMethodRouter {
    
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
    
    private func checkFirebaseUser() {
        
        //        // TODO: we should implement an auto retry
        //        guard let _ = Configure.current.session?.sdkFirebaseUser else {
        //            report(.addPaymentMethodSdkNotInitialized, failure)
        //            return
        //        }
        
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
