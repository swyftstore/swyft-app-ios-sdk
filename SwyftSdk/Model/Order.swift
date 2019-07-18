//
//  Order.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/18/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

public class Order:  FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var customerId: String?
    @objc public var preAuthAmount: String?
    @objc public var createDateTime: String?
    @objc public var updateDateTime: String?
    @objc public var subTotal: String?
    @objc public var total: String?
    @objc public var tax: String?
    @objc public var isSettled = false
    @objc public var storeTransactions: [StoreTransactions]?
    
    
    public func toString() {
        
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            if responds(to: Selector(keyName)) {
                if "storeTransactions" == keyName,
                    let values = value as? Array<Dictionary<String, Any>> {
                    //todo: this is hacky
                    var _products = [StoreTransactions]()
                    for val in values {
                        let product = StoreTransactions()
                        product.serialize(data: val)
                        _products.append(product)
                    }
                    setValue(_products, forKey: keyName)
                } else {
                    setValue(value, forKey: keyName)
                }
            }
        }
    }
    
}
