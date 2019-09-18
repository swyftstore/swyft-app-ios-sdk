//
//  EditPaymentMethodRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/18/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class EditPaymentMethodRouter {
    
    // MARK: Singleton
    static let shared = EditPaymentMethodRouter()
    private init() {}
    
    // MARK: Data
    private var method: PaymentMethod!
    private var isDefault: Bool!
    private var success: SwyftEditPaymentMethodCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ method: PaymentMethod, _ isDefault: Bool, _ success: @escaping SwyftEditPaymentMethodCallback, _ failure: @escaping SwyftFailureCallback) {
        
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
private extension EditPaymentMethodRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.editPaymentMethodSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        editMethod()
    }
    
    private func editMethod() {
        
        guard let cardNumber = method.cardNumber,
            let cardExpiry = method.cardExpiry,
            let cardType = method.cardType,
            let cardHolderName = method.cardHolderName,
            let cvv = method.cvv,
            let merchantRef = method.merchantRef else {
                
            report(.editPaymentMethodInvalidCardData, self.failure)
            return
        }
        
        let methodToEdit = EditPaymentMethod(
            cardNumber: cardNumber,
            cardExpiry: cardExpiry,
            cardType: cardType,
            cardHolderName: cardHolderName,
            cvv: cvv,
            merchantRef: merchantRef)
        
        EditPaymentInteractor.editPaymentMethod(method: methodToEdit, isDefault: isDefault, success: { paymentMethod in
            
            let result = SwyftEditPaymentMethodResponse(paymentMethod: paymentMethod)
            self.callSuccess(using: result)
            
        }) { error in
            report(.editPaymentMethodSdkNotInitialized, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftEditPaymentMethodResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
