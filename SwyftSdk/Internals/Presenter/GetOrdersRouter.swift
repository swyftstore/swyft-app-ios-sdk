//
//  GetOrdersRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class GetOrdersRouter {
    
    // MARK: Singleton
    static let shared = GetOrdersRouter()
    private init() {}
    
    // MARK: Data
    private var customerId: String!
    private var start: Int!
    private var pageSize: Int!
    private var success: SwyftGetOrdersCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ customerId: String, _ start: Int, _ pageSize: Int, _ success: @escaping SwyftGetOrdersCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.customerId = customerId
        self.start = start
        self.pageSize = pageSize
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
    
    private func checkFirebaseUser() {
        
        //        // TODO: we should implement an auto retry
        //        guard let _ = Configure.current.session?.sdkFirebaseUser else {
        //            report(.getOrdersSdkNotInitialized, failure)
        //            return
        //        }

        getOrders()
    }
    
    private func getOrders() {
        
        let action = GetOrders(success: { data in
            
            guard let orders = data as? [Order] else {
                report(.getOrdersParsingFailure, self.failure)
                return
            }
            
            let result = SwyftGetOrdersResponse(orders: orders)
            self.callSuccess(using: result)
            
        }) { error in
            report(.getOrdersFirebaseFailure, self.failure)
        }
        
        action.get(customerId: customerId, startIndex: start, limit: pageSize)
    }
    
    private func callSuccess(using response: SwyftGetOrdersResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
