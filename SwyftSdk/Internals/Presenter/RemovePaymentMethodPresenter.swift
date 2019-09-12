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
    
    func execute(_ methodId: String, _ success: SwyftDeleteMethodCallback, _ failure: SwyftFailureCallback) {
        
    }
}
