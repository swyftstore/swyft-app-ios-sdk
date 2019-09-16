//
//  RemovePaymentResponse.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

class RemoveMethodResponse: XmlResponseBase {
    private let cardRefKey = "CARDREFERENCE"
    private let hashKey = "HASH"
    
    private var hashCode: String?

    var cardRef: String?
    
    required init?(map: XMLMap) {
        super.init()
        merchantRef = map[merchantRefKey].currentValue as? String
        cardRef = map[cardRefKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue as? String
        hashCode = map[hashKey].currentValue as? String
      
    }
    
    func compareHash() -> Bool {
        //TERMINALID:MERCHANTREF:DATETIME:SECRET
        let _hashCode = Utils.createPaymentHash(signature: "\(terminalId!):\(merchantRef!):\(dateTime!):\(secret)")
        
        return _hashCode == self.hashCode
    }
    
}

extension RemoveMethodResponse: XMLMappable {
    var nodeName: String! {
        get {
            return "SECURECARDREMOVALRESPONSE"
        }
        set(newValue) {
        }
    }
    
    func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        cardRef <- map[cardRefKey]
        dateTime <- map[dateTimeKey]
        hashCode <- map[hashKey]
    }
}
