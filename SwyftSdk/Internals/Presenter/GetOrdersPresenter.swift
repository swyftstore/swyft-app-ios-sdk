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
    
    func execute(_ start: Int, _ pageSize: Int, _ success: SwyftGetOrdersCallback, _ failure: SwyftFailureCallback) {
        
    }
}
