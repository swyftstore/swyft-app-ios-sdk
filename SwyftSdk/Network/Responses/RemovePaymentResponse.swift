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
    
    required public init?(map: XMLMap) {
        super.init()
        merchantRef = map[merchantRefKey].currentValue as? String
        cardRef = map[cardRefKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue as? String
        hashCode = map[hashKey].currentValue as? String
      
    }
    
    func compareHash() -> Bool {
        //TERMINALID:MERCHANTREF:CARDREFERENCE:DATETIME:SECRET
        let _hashCode = Utils.createPaymentHash(prefix: "\(terminalId!):\(merchantRef!):\(cardRef!):\(dateTime!)", secret: secret)
        
        return _hashCode == self.hashCode
    }
    
}

extension RemoveMethodResponse: XMLMappable {
    public var nodeName: String! {
        get {
            return "SECURECARDREMOVALRESPONSE"
        }
        set(newValue) {
        }
    }
    
    public func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        cardRef <- map[dateTimeKey]
        dateTime <- map[cardRefKey]
        hashCode <- map[hashKey]
    }
}
