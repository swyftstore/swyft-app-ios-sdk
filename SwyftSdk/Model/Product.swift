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
    @objc public var desc: String?
    @objc public var brand: String?
    @objc public var category: String?
    @objc public var subCategroy: String?
    @objc public var weight = 0
    @objc public var ageRestricted: String?
    @objc public var totalInventory = 0
    @objc public var createdOn: String?
    @objc public var merchantNames: [String]?
    @objc public var storeIds: [String]?
    @objc public var dimensions: Dimensions?
    
    
    public func toString() {
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            
            if responds(to: Selector(keyName)) {
                if "dimensions" == keyName,
                    let dict = value as? Dictionary<String, Any> {
                    //todo: this is hacky
                    let dims = Dimensions()
                    dims.serialize(data: dict)
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

public class Dimensions: FireStoreModelSerialize, FireStoreModelProto  {
    @objc public var h = 0
    @objc public var w = 0
    @objc public var l = 0
    
    
    public func toString() {
        
    }
    
   
    
    
}

