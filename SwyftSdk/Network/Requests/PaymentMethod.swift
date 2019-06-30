//
//  PaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

public class PaymentMethod: XmlRequestBase {

    private let cardNumberKey = "CARDNUMBER"
    private let cardExpiryKey = "CARDEXPIRY"
    private let cardTypeKey = "CARDTYPE"
    private let cardHolderNameKey = "CARDHOLDERNAME"
    private let cvvKey = "CVV"
    private let hashKey = "HASH"
    
    private var hashCode: String?
    
    var cardNumber: String?
    var cardExpiry: String?
    var cardType: String?
    var cardHolderName: String?
    var cvv: String?
    
    var last4 : String? {
        get {
            if let _ = cardNumber {
                return String(cardNumber!.suffix(4))
            } else {
                return "0000"
            }
        }
    }
    
    init(cardNumber: String,
         cardExpiry: String, cardType: String, cardHolderName: String, cvv: String) {
        super.init()
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.cardHolderName = cardHolderName
        self.cardExpiry = cardExpiry
        self.cvv = cvv
        
        let prefix = "\(terminalRef!):\(merchantRef!):\(dateTime!):\(self.cardNumber!):\(self.cardType!):\(self.cardHolderName!)"
        self.hashCode = Utils.createPaymentHash(prefix: prefix, secret: secret)
    }
    
    required public init?(map: XMLMap) {
        super.init()
        merchantRef = map[merchantRefKey].currentValue as? String
        terminalRef = map[terminalRefKey].currentValue as? String
        cardNumber = map[cardNumberKey].currentValue as? String
        cardExpiry = map[cardExpiryKey].currentValue as? String
        cardType = map[cardTypeKey].currentValue as? String
        cardHolderName = map[cardHolderNameKey].currentValue as? String
        cvv = map[cvvKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue as? String
        hashCode = map[hashKey].currentValue as? String
        
    }
    
    
    
}

extension PaymentMethod: XMLMappable {
    public var nodeName: String! {
        get {
            return "SECURECARDREGISTRATION"
        }
        set(newValue) {
        }
    }
    
    
    
    public func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        terminalRef <- map[terminalRefKey]
        cardNumber <- map[cardNumberKey]
        cardExpiry <- map[cardExpiryKey]
        cardType <- map[cardTypeKey]
        cardHolderName <- map[cardHolderNameKey]
        cvv <- map[cvvKey]
        hashCode <- map[hashKey]
    }
    
    
}
