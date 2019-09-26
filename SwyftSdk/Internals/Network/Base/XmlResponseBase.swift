//
//  XmlResponseBase.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

internal class XmlResponseBase {
    
    let dateTimeKey = "DATETIME"
    let merchantRefKey = "MERCHANTREF"
    let terminalIdKey = "TERMINALID"
    
    var merchantRef: String?
    var terminalId: String?
    var dateTime: String?
    
    
    var secret: String
    
    init() {
        secret = XmlResponseBase.getPaymentSecret()
        terminalId = XmlResponseBase.getTerminalId()
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
}
