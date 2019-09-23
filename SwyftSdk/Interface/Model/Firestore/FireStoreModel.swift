//
//  FireStoreModel.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import SwiftTryCatch

protocol FireStoreModelProto {
    func toString()
}

public class FireStoreModelSerialize: NSObject {
    
    func serialize(data: Dictionary<String, Any>) {
        
        for (key, value) in data {
            let keyName = key as String
            SwiftTryCatch.try({
                self.setValue(value, forKey: keyName)
            }, catch: { (error) in
                print("Error serializing data \(error!.description)")
            }, finally: {})
            
        }
    }
    
    func deserialize() -> Dictionary<String, Any> {
        
        var dict:[String:Any] = [:]
        
        for prop in propertyNames() {
            if prop != "id" {
                if let val = value(forKey: prop) as? String {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Bool {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Int {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Double {
                    dict[prop] = val
                } else if let val = value(forKey: prop) as? Array<String> {
                    dict[prop] = val
                } else if let vals = value(forKey: prop) as? [SwyftPaymentMethod] {
                    var _vals: [Any] = []
                    for val in vals {
                        let data = val.deserialize()
                        _vals.append(data)
                    }
                    dict[prop] = _vals
                } else if let vals = value(forKey: prop) as? [String: SwyftPaymentMethod] {
                    var _vals: [String: Any] = [:]
                    for (key, val)in vals {
                        let data = val.deserialize()
                        _vals[key] = data
                    }
                    dict[prop] = _vals
                } else if let val = value(forKey: prop) as? FireStoreModelSerialize {
                    dict[prop] = val.deserialize()
                }
            }
        }
        
        return dict
        
    }
}

private extension FireStoreModelSerialize {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}

