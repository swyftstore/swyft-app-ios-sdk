//
//  Order.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/18/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import SwiftTryCatch

public class Order:  FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var customerId: String?
    @objc public var preAuthAmount = 0.0
    @objc public var createDateTime = 0
    @objc public var updateDateTime = 0
    @objc public var subTotal = 0.0
    @objc public var total = 0.0
    @objc public var tax = 0.0
    @objc public var settled = false
    @objc public var merchantName: String?
    @objc public var storeTransactions: [StoreTransactions]?
    
    
    public func toString() {
        
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        SwiftTryCatch.try({
            for (key, value) in data {
                let keyName = key as String
                if self.responds(to: Selector(keyName)) {
                    if "storeTransactions" == keyName,
                        let values = value as? Dictionary<String,Dictionary<String, Any>> {
                        //todo: this is hacky
                        var _products = [StoreTransactions]()
                        for (key, _value) in values {
                            let product = StoreTransactions()
                            product.serialize(data: _value)
                            product.id = key
                            _products.append(product)
                        }
                        self.setValue(_products, forKey: keyName)
                    } else {
                        self.setValue(value, forKey: keyName)
                    }
                }
            }
        }, catch: { (error) in
            print("Error serializing data \(error!.description)")
        }, finally: {})
        
    }
    
}

public class Address: FireStoreModelSerialize, FireStoreModelProto {
    
    @objc public var address1: String?
    @objc public var address2: String?
    @objc public var city: String?
    @objc public var zip: String?
    @objc public var state: String?
    @objc public var country: String?
    @objc public var providence: String?
    
    public func toString() {
        //todo
    }
    
    
}
