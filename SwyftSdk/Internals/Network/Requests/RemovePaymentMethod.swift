//
//  RemovePaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

class RemovePaymentMethod: XmlRequestBase {
 
    private let cardRefKey = "CARDREFERENCE"
    private let hashKey = "HASH"
    
    private var hashCode: String?
    
    var cardRef: String?
    
    init(cardRef: String, merchantRef: String) {
        super.init()
        self.cardRef = cardRef;
        self.merchantRef = merchantRef;
        //TERMINALID:MERCHANTREF:DATETIME:CARDREFERENCE:SECRET
        let signature = "\(terminalId!):\(merchantRef):\(dateTime!):\(self.cardRef!):\(secret)"
        
        self.hashCode = Utils.createPaymentHash(signature: signature)
    }
    
    required init?(map: XMLMap) {
        super.init()
        terminalId = map[terminalIdKey].currentValue as? String
        cardRef = map[cardRefKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue  as? String
        hashCode = map[hashKey].currentValue as? String
    }
}

extension RemovePaymentMethod: XMLMappable {
    var nodeName: String! {
        get {
            return "SECURECARDREMOVAL"
        }
        set(newValue) {
        }
    }
    
    func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        terminalId <- map[terminalIdKey]
        cardRef <- map[cardRefKey]
        hashCode <- map[hashKey]
    }
    

    func toXMLString() -> String  {
        var xml = "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?> <\(nodeName!)>"
        
        xml = "\(xml)\(buildXMLTag(key: merchantRefKey, value:merchantRef))"
        xml = "\(xml)\(buildXMLTag(key: cardRefKey, value: cardRef))"
        xml = "\(xml)\(buildXMLTag(key: terminalIdKey, value:terminalId))"
        xml = "\(xml)\(buildXMLTag(key: dateTimeKey, value: dateTime))"
        xml = "\(xml)\(buildXMLTag(key: hashKey, value:hashCode))"
        xml = "\(xml)</\(nodeName!)>"
        
        return  xml
    }
}
