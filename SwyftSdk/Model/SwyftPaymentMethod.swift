//
//  SwyftPaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/25/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class SwyftPaymentMethod: FireStoreModelSerialize, FireStoreModelProto  {
   
    @objc public var token: String?
    @objc public var last4: String?
    @objc public var cardType: String?
    @objc public var cardExpiry: String?
    @objc public var isDefault = false
    
    public func toString() {
        //todo
    }
    
    public func isExpired() -> Bool {
        if let _cardExpiry = cardExpiry {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMyy"
            if let date = dateFormatter.date(from: _cardExpiry),
                Date() > date {
                return true
            }
        }
        return false
    }
}
