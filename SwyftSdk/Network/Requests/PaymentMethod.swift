//
//  PaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

public class PaymentMethod: XMLModel {
    private let merchantRefKey = "MERCHANTREF"
    private let terminalRefKey = "TERMINALID"
    private let cardNumberKey = "CARDNUMBER"
    private let cardExpiryKey = "CARDEXPIRY"
    private let cardTypeKey = "CARDTYPE"
    private let cardHolderNameKey = "CARDHOLDERNAME"
    private let dateTimeKey = "DATETIME"
    private let cvvKey = "CVV"
    private let hashKey = "HASH"
    
    private var dateTime: String
    private var hash: String
    
    var merchantRef: String
    var terminalRef: String
    var cardNumber: String
    var cardExpiry: String
    var cardType: String
    var cardHolderName: String
    var cvv: String
    
    var last4 : String {
        get {
            return String(cardNumber.suffix(4))
        }
    }
    
    init(merchantRef: String, terminalRef: String, cardNumber: String,
         cardExpiry: String, cardType: String, cardHolderName: String, cvv: String) {
        self.merchantRef = merchantRef
        self.terminalRef = terminalRef
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.cardHolderName = cardHolderName
        self.cardExpiry = cardExpiry
        self.cvv = cvv
        self.dateTime = Utils.getPaymentDateTime()
        
        let prefix = "\(terminalRef)\(merchantRef)\(dateTime)\(cardNumber)\(cardType)\(cardHolderName)"
        if let secret = Utils.getPaymentSecret() {
            self.hash = Utils.createPaymentHash(prefix: prefix, secret: secret)
        } else {
            self.hash = Utils.createPaymentHash(prefix: prefix, secret: "")
        }
        super.init()
       
    }
    
    required public init?(map: XMLMap) {
        merchantRef = map[merchantRefKey].currentValue as! String
        terminalRef = map[terminalRefKey].currentValue as! String
        cardNumber = map[cardNumberKey].currentValue as! String
        cardExpiry = map[cardExpiryKey].currentValue as! String
        cardType = map[cardTypeKey].currentValue as! String
        cardHolderName = map[cardHolderNameKey].currentValue as! String
        cvv = map[cvvKey].currentValue as! String
        dateTime = map[dateTimeKey].currentValue as! String
        hash = map[hashKey].currentValue as! String
        super.init()
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
        hash <- map[hashKey]
    }
    
    
}
