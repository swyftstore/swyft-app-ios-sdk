//
//  Store.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/17/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


class Store: FireStoreModelSerialize, FireStoreModelProto {
    public var id: String?
    
    @objc public var name: String?
    @objc public var merchantName: String?
    @objc public var status: String?
    @objc public var products: [Product]?
    @objc public var location: Location?
    @objc public var hours: [Hours]?

        
    
    func toString() {
        //todo
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
                } else if "geoPoint" == keyName, let values = value as? Dictionary<String, Any> {
                        let geoPoint = GeoPoint()
                        geoPoint.serialize(data: values)
                        setValue(value, forKey: "geoPoint")
                } else if "location" == keyName, let values = value as? Dictionary<String, Any> {
                        let location = Location()
                        location.serialize(data: values)
                        setValue(value, forKey: "location")
                } else if "hours" == keyName, let values = value as? Array<Dictionary<String, Any>> {
                        var hoursArray = [Hours]()
                        for value in values {
                            let hours = Hours()
                            hours.serialize(data: value)
                            hoursArray.append(hours)
                        }
                        setValue(hoursArray, forKey: "hours")
                } else {
                    setValue(value, forKey: keyName)
                }
            }
        }
    }
    
}


class Location: FireStoreModelSerialize, FireStoreModelProto  {
    
    @objc public var address1: String?
    @objc public var address2: String?
    @objc public var city: String?
    @objc public var state: String?
    @objc public var zip: String?
    @objc public var country: String?
    @objc public var geoPoint: GeoPoint?
    
    func toString() {
        //todo
    }
    
    
}

class Hours: FireStoreModelSerialize, FireStoreModelProto {
    
    @objc public var open: String?
    @objc public var close: String?
    
    func toString() {
        //todo
    }
    
    
}

class GeoPoint: FireStoreModelSerialize, FireStoreModelProto  {
    
    @objc public var lat: String?
    @objc public var lng: String?
    
    func toString() {
        //todo
    }
    
    
}
