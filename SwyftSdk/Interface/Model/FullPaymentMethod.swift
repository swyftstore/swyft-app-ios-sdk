//
//  EditSwyftPaymentMethod.swift
//  Alamofire
//
//  Created by Tom Manuel on 9/19/19.
//

import Foundation

public class FullPaymentMethod {
    
    @objc public var cardNumber: String?
    @objc public var cvv: String?
    @objc public var token: String?
    @objc public var cardType: String?
    @objc public var cardExpiry: String?
    @objc public var cardholderName: String?
    @objc public var merchantRef: String?
    
    public init(from swyftPaymentMethod: SwyftPaymentMethod) {
        self.token = swyftPaymentMethod.token
        self.cardType = swyftPaymentMethod.cardType
        self.cardExpiry = swyftPaymentMethod.cardExpiry
        self.cardholderName = swyftPaymentMethod.cardholderName
        self.merchantRef = swyftPaymentMethod.merchantRef
    }
    
    public init(cardNumber: String,
                cardExpiry: String,
                cardType: String,
                cardHolderName: String,
                cvv: String) {
        self.cardNumber = cardNumber
        self.cardExpiry = cardExpiry
        self.cardType = cardType
        self.cardholderName = cardHolderName
        self.cvv = cvv
    }
    
    public init() {
        
    }
}
