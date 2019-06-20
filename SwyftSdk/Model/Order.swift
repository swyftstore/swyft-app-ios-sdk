//
//  Order.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/3/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

public class Order:  FireStoreModelSerialize, FireStoreModelProto {
    
    public var id: String?
    @objc public var desc: String?
    @objc public var createdOn: String?
    @objc public var timeZone: String?
    @objc public var status: String?
    @objc public var currancy: String?
    @objc public var amount: String?
    @objc public var customerId: String?
    @objc public var merchantName: String?
    
    @objc public var products: [Product]?
    @objc public var promoCodes: [String]?
    @objc public var storeIds: [String]?
    
    
    public func toString() {
        
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            if responds(to: Selector(keyName)) {
                if "products" == keyName,
                    let values = value as? Array<Dictionary<String, Any>> {
                    //todo: this is hacky 
                        var _products = [Product]()
                        for val in values {
                            let product = Product()
                            product.serialize(data: val)
                            _products.append(product)
                        }
                    setValue(_products, forKey: keyName)
                } else if "description" == keyName {
                    //todo: this is hacky
                    setValue(value, forKey: "desc")
                } else {
                    setValue(value, forKey: keyName)
                }
            }
        }
    }
    
}
