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
    @objc public var orderQuantity = 0
    @objc public var price: String?
    @objc public var ageRestricted: String?
    @objc public var sku: String?
    @objc public var upc: String?
    
    
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

public class Dimensions: FireStoreModelSerialize, FireStoreModelProto  {
    @objc public var h = 0
    @objc public var w = 0
    @objc public var l = 0
    
    
    public func toString() {
        
    }
    
   
    
    
}

