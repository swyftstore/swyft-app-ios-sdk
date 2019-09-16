//
//  Product.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/3/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class Product: FireStoreModelSerialize, FireStoreModelProto  {
    
    
    public var id: String?
    
    @objc public var name: String?
    @objc public var orderedQuantity = 0
    @objc public var price = 0.0
    @objc public var ageRestricted = false
    @objc public var sku: String?
    @objc public var upc: String?
    @objc public var imageURL: String?
    
    
    public func toString() {
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            
            if responds(to: Selector(keyName)) {
                setValue(value, forKey: keyName)
            }
            
        }
    }
    
}
