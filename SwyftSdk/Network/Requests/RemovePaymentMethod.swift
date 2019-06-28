//
//  RemovePaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

public class RemovePaymentMethod: XmlRequestBase {
 
    private let cardRefKey = "CARDREFERENCE"
    private let hashKey = "HASH"
    
    private var hashCode: String?
    
    var cardRef: String?
    
    init(cardRef: String) {
        super.init()
        self.cardRef = cardRef;
        //TERMINALID:MERCHANTREF:DATETIME:CARDREFERENCE:SECRET
        let prefix = "\(terminalRef!):\(merchantRef!):\(dateTime!):\(self.cardRef!)"
        
        self.hashCode = Utils.createPaymentHash(prefix: prefix, secret: secret)
    }
    
    required public init?(map: XMLMap) {
        super.init()
        terminalRef = map[terminalRefKey].currentValue as? String
        cardRef = map[cardRefKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue  as? String
        hashCode = map[hashKey].currentValue as? String
    }
}

extension RemovePaymentMethod: XMLMappable {
    public var nodeName: String! {
        get {
            return "SECURECARDREMOVAL"
        }
        set(newValue) {
        }
    }
    
    public func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        terminalRef <- map[terminalRefKey]
        cardRef <- map[cardRefKey]
        hashCode <- map[hashKey]
    }    
}
