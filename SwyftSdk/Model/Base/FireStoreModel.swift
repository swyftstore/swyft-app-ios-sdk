//
//  FireStoreModel.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation



public protocol FireStoreModelProto {
    
    func toString()
}

public class FireStoreModelSerialize: NSObject {
    public func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            
            if responds(to: Selector(keyName)) {
                setValue(value, forKey: keyName)
            }
            
        }
    }
    
    public func deserialize() -> Dictionary<String, Any> {
        
        var dict:[String:Any] = [:]
        
        for prop in propertyNames() {
            if prop != "id" {
                if let val = value(forKey: prop) as? String {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Int {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Double {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Array<String> {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? FireStoreModelSerialize {
                    dict[prop] = val.deserialize()
                }
            }
        }
        
        return dict
        
    }
}


extension FireStoreModelSerialize {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}
