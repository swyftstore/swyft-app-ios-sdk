//
//  Store.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/17/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import SwiftTryCatch

public class Store: FireStoreModelSerialize, FireStoreModelProto {
    public var id: String?
    
    @objc public var name: String?
    @objc public var merchantName: String?
    @objc public var status: String?
    @objc public var products: [Product]?
    @objc public var location: Location?
    @objc public var hours: [Hours]?

        
    
    public func toString() {
        //todo
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        SwiftTryCatch.try({
            for (key, value) in data {
                let keyName = key as String
                if self.responds(to: Selector(keyName)) {
                    if "products" == keyName,
                        let values = value as? Array<Dictionary<String, Any>> {
                        //todo: this is hacky
                        var _products = [Product]()
                        for val in values {
                            let product = Product()
                            product.serialize(data: val)
                            _products.append(product)
                        }
                        self.setValue(_products, forKey: keyName)
                    } else if "location" == keyName, let values = value as? Dictionary<String, Any> {
                        let location = Location()
                        location.serialize(data: values)
                        self.setValue(location, forKey: "location")
                    } else if "hours" == keyName, let values = value as? Array<Dictionary<String, Any>> {
                        var hoursArray = [Hours]()
                        for value in values {
                            let hours = Hours()
                            hours.serialize(data: value)
                            hoursArray.append(hours)
                        }
                        self.setValue(hoursArray, forKey: "hours")
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


public class Location: FireStoreModelSerialize, FireStoreModelProto  {
    
    @objc public var address1: String?
    @objc public var address2: String?
    @objc public var city: String?
    @objc public var state: String?
    @objc public var zip: String?
    @objc public var country: String?
    @objc public var geoPoint: GeoPoint?
    
    public func toString() {
        //todo
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        SwiftTryCatch.try({
            for (key, value) in data {
                let keyName = key as String
                if self.responds(to: Selector(keyName)) {
                    if "geoPoint" == keyName, let values = value as? Dictionary<String, Any> {
                        let geoPoint = GeoPoint()
                        geoPoint.serialize(data: values)
                        self.setValue(geoPoint, forKey: "geoPoint")
                    } else if let _value = value as? String{
                        self.setValue(_value, forKey: keyName)
                    }
                }
            }
        }, catch: { (error) in
            print("Error serializing data \(error!.description)")
        }, finally: {})
        
    }
    
}

public class Hours: FireStoreModelSerialize, FireStoreModelProto {
    
    @objc public var open: String?
    @objc public var close: String?
    
    public func toString() {
        //todo
    }
    
}

public class GeoPoint: FireStoreModelSerialize, FireStoreModelProto  {
    
    @objc public var lat = 0.0
    @objc public var lng = 0.0
    
    public func toString() {
        //todo
    }
    
    override public func serialize(data: Dictionary<String, Any>) {
        SwiftTryCatch.try({
            for (key, value) in data {
                let keyName = key as String
                if self.responds(to: Selector(keyName)) {
                     if let _value = value as? Double{
                        self.setValue(_value, forKey: keyName)
                    }
                }
            }
        }, catch: { (error) in
            print("Error serializing data \(error!.description)")
        }, finally: {})
        
    }
}
