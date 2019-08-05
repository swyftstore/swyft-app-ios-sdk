//
//  XMLModel.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import CryptoSwift

public class XmlRequestBase{
    let merchantRefKey = "MERCHANTREF"
    let terminalIdKey = "TERMINALID"
    let dateTimeKey = "DATETIME"
    
    var merchantRef: String?
    var terminalId: String?
    var dateTime: String?    
    var secret: String
    
     init() {
        merchantRef = XmlRequestBase.getMerchantRef()
        terminalId = XmlRequestBase.getTerminalId()
        secret = XmlRequestBase.getPaymentSecret()
        dateTime = Utils.getPaymentDateTime()    
    }
    
    private class func getPaymentSecret() -> String {
        var secret = ""
        if let _url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:_url)
                let infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                secret = infoPlist["PAYMENT_SECRET"] as! String
            } catch {
                print(error)
            }
        }
        return secret
    }
    
    private static func getMerchantRef() -> String {
        var merchantRef = ""
        if let _url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:_url)
                let infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                merchantRef = infoPlist["MERCHENT_REF"] as! String
            } catch {
                print(error)
            }
        }
        return merchantRef
    }
    
    private static func getTerminalId() -> String {
        var terminalRef = ""
        if let _url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:_url)
                let infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                terminalRef = infoPlist["TERMINAL_ID"] as! String
            } catch {
                print(error)
            }
        }
        return terminalRef
    }
    
    func buildXMLTag(key: String, value: String?) -> String {
        var tag: String
        if let value = value {
            tag = "<\(key)>\(value)</\(key)>"
        } else {
            tag = "<\(key)></\(key)>"
        }
        return tag
    }
    
}
