//
//  GetOrdersPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class GetOrdersPresenter {
    
    // MARK: Singleton
    static let shared = GetOrdersPresenter()
    private init() {}
    
    func execute(_ customerId: String, _ start: Int, _ pageSize: Int, _ success: @escaping SwyftGetOrdersCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.getOrdersSdkNotInitialized, failure)
            return
        }
        
        let action = GetOrders(success: { data in
            
            guard let orders = data as? [Order] else {
                report(.getOrdersParsingFailure, failure)
                return
            }
            
            let response = SwyftGetOrdersResponse(orders: orders)
            success(response)
            
        }) { error in
            report(.getOrdersFirebaseFailure, failure)
        }
        
        action.get(customerId: customerId, startIndex: start, limit: pageSize)
    }
}
