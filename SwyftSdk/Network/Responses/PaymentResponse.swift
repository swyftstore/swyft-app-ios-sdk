//
//  PaymentResponse.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/25/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

class PaymentMethodResponse: XMLModel {
    private let merchantRefKey = "MERCHANTREF"
    private let cardRefKey = "CARDREFERENCE"
    private let dateTimeKey = "DATETIME"
    private let hashKey = "HASH"
    
    private var hash: String
    var merchantRef: String
    var dateTime: String
    var cardRef: String
    
    required public init?(map: XMLMap) {
        merchantRef = map[merchantRefKey].currentValue as! String
        cardRef = map[cardRefKey].currentValue as! String
        dateTime = map[dateTimeKey].currentValue as! String
        hash = map[hashKey].currentValue as! String
        super.init()
    }
   
}

extension PaymentMethodResponse: XMLMappable {
    public var nodeName: String! {
        get {
            return "SECURECARDREGISTRATIONRESPONSE"
        }
        set(newValue) {
        }
    }
    
    public func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        cardRef <- map[dateTimeKey]
        dateTime <- map[cardRefKey]
        hash <- map[hashKey]
    }
}
