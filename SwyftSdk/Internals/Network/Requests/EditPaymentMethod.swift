//
//  EditPaymentMethod.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/5/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


import Foundation
import XMLMapper

internal class EditPaymentMethod: XmlRequestBase {
    
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
    
    init(cardNumber: String?,
         cardExpiry: String, cardType: String,
         cardHolderName: String, cvv: String?, merchantRef: String) {
        super.init()
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.cardHolderName = cardHolderName
        self.cardExpiry = cardExpiry
        self.cvv = cvv
        self.merchantRef = merchantRef
        
        //TERMINALID:MERCHANTREF:DATETIME:CARDEXPIRY:CARDHOLDERNAME:SECRET

        let signature = "\(terminalId!):\(merchantRef):\(dateTime!):\(cardExpiry):\(cardHolderName):\(secret)"
        self.hashCode = Utils.createPaymentHash(signature: signature)
    }
    
    required init?(map: XMLMap) {
        super.init()
        merchantRef = map[merchantRefKey].currentValue as? String
        terminalId = map[terminalIdKey].currentValue as? String
        cardNumber = map[cardNumberKey].currentValue as? String
        cardExpiry = map[cardExpiryKey].currentValue as? String
        cardType = map[cardTypeKey].currentValue as? String
        cardHolderName = map[cardHolderNameKey].currentValue as? String
        cvv = map[cvvKey].currentValue as? String
        dateTime = map[dateTimeKey].currentValue as? String
        hashCode = map[hashKey].currentValue as? String
        
    }
    
    
    
}

extension EditPaymentMethod: XMLMappable {
    var nodeName: String! {
        get {
            return "SECURECARDUPDATE"
        }
        set(newValue) {
        }
    }
    
    func mapping(map: XMLMap) {
        merchantRef <- map[merchantRefKey]
        terminalId <- map[terminalIdKey]
        cardNumber <- map[cardNumberKey]
        cardExpiry <- map[cardExpiryKey]
        cardType <- map[cardTypeKey]
        cardHolderName <- map[cardHolderNameKey]
        cvv <- map[cvvKey]
        hashCode <- map[hashKey]
    }
    
    func toXMLString() -> String  {
        var xml = "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?> <\(nodeName!)>"
        
        xml = "\(xml)\(buildXMLTag(key: merchantRefKey, value:merchantRef))"
        xml = "\(xml)\(buildXMLTag(key: terminalIdKey, value: terminalId))"
        xml = "\(xml)\(buildXMLTag(key: dateTimeKey, value: dateTime))"
        xml = "\(xml)\(buildXMLTag(key: cardExpiryKey, value:cardExpiry))"
        xml = "\(xml)\(buildXMLTag(key: cardHolderNameKey, value:cardHolderName))"
        xml = "\(xml)\(buildXMLTag(key: hashKey, value:hashCode))"
        xml = "\(xml)\(buildXMLTag(key: cvvKey, value:cvv))"
        xml = "\(xml)</\(nodeName!)>"
        
        return  xml
    }
}
