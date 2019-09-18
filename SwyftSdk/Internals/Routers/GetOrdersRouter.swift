//
//  GetOrdersRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class GetOrdersRouter {
    
    // MARK: Singleton
    static let shared = GetOrdersRouter()
    private init() {}
    
    // MARK: Data
    private var start: Int!
    private var pageSize: Int!
    private var success: SwyftGetOrdersCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ start: Int, _ pageSize: Int, _ success: @escaping SwyftGetOrdersCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.start = start
        self.pageSize = pageSize
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
}

// MARK: Internals
private extension GetOrdersRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.getOrdersSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        getCustomer()
    }
    
    private func getCustomer() {
        
        guard let email = Configure.current.session?.sdkFirebaseUser?.email else {
            report(.getOrdersNoFirebaseUser, self.failure)
            return
        }
        
        let action = GetCustomer(success: { data in
            
            guard let customer = data as? Customer else {
                report(.getOrdersInvalidCustomerData, self.failure)
                return
            }
            
            guard let customerId = customer.id else {
                report(.getOrdersNoCustomerId, self.failure)
                return
            }
            
            self.getOrders(for: customerId)
            
        }) { error in
            report(.getOrdersGetCustomerFailure, self.failure)
        }
        
        action.get(email: email)
    }
    
    private func getOrders(for customerId: String) {
        
        let action = GetOrders(success: { data in
            
            guard let orders = data as? [Order] else {
                report(.getOrdersParsingFailure, self.failure)
                return
            }
            
            let result = SwyftGetOrdersResponse(orders: orders)
            self.callSuccess(using: result)
            
        }) { error in
            
            if error == "document not found" {
                let result = SwyftGetOrdersResponse(orders: [])
                self.callSuccess(using: result)
            } else {
                report(.getOrdersFirebaseFailure, self.failure)
            }
        }
        
        action.get(customerId: customerId, startIndex: start, limit: pageSize)
    }
    
    private func callSuccess(using response: SwyftGetOrdersResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
