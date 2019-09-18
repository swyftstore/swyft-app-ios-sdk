//
//  GetPaymentMethodsRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class GetPaymentMethodsRouter {
    
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
}

// MARK: Internals
private extension GetPaymentMethodsRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.getPaymentMethodsSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        getCustomer()
    }
    
    private func getCustomer() {
        
        guard let email = Configure.current.session?.sdkFirebaseUser?.email else {
            report(.getPaymentMethodsNoFirebaseUser, self.failure)
            return
        }
        
        let action = GetCustomer(success: { data in
            
            guard let customer = data as? Customer else {
                report(.getPaymentMethodsInvalidCustomerData, self.failure)
                return
            }
            
            guard let customerId = customer.id else {
                report(.getPaymentMethodsNoCustomerId, self.failure)
                return
            }
            
            self.getMethods(for: customerId)
            
        }) { error in
            report(.getPaymentMethodsGetCustomerFailure, self.failure)
        }
        
        action.get(email: email)
    }
    
    private func getMethods(for customerId: String) {
        
        let action = GetPaymentMethods(success: { data in

            guard let methods = data as? [PaymentMethod] else {
                report(.getPaymentMethodsParsingFailure, self.failure)
                return
            }

            let result = SwyftGetPaymentMethodsResponse(paymentMethods: methods)
            self.callSuccess(using: result)

        }) { error in
            report(.getPaymentMethodsFirebaseFailure, self.failure)
        }

        action.get(id: customerId)
    }
    
    private func callSuccess(using response: SwyftGetPaymentMethodsResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
