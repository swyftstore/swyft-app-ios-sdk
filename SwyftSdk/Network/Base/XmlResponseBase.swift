//
//  XmlResponseBase.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

class XmlResponseBase {
    
    let dateTimeKey = "DATETIME"
    let merchantRefKey = "MERCHANTREF"
    
    var merchantRef: String?
    var dateTime: String?
    
    var secret: String
    
    init() {
        secret = XmlResponseBase.getPaymentSecret()
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
}
