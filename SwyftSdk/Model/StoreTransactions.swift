//
//  Order.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/3/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

public class StoreTransactions:  FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var storeId: String?
    @objc public var lastUpdated: String?
    @objc public var cartItems: [Product]?
    @objc public var total = 0.0
    @objc public var subtotal = 0.0
    @objc public var tax = 0.0
    
    
    public func toString() {
        
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            if responds(to: Selector(keyName)) {
                if "cartItems" == keyName,
                    let values = value as? Dictionary<String, Dictionary<String, Any>> {
                    var _products = [Product]()
                    for (_key, val) in values {
                        let product = Product()
                        product.serialize(data: val)
                        product.id = _key
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
