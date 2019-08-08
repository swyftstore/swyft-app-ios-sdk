//
//  Utils.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/7/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


class Utils: NSObject {
    static func getBaseURL() -> URL? {
        var url: URL?
        if let _url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:_url)
                let infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                let urlString = infoPlist["ENVIRONMENT_URL"] as! String
                url = URL(string: urlString)
            } catch {
                print(error)
            }
        }
        return url
    }
    
    static func getPyamentURL() -> URL? {
        var url: URL?
        if let _url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:_url)
                let infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                let urlString = infoPlist["PAYMENT_URL"] as! String
                url = URL(string: urlString)
            } catch {
                print(error)
            }
        }
        return url
    }
    
    static func getPaymentDateTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY:HH:mm:ss:SSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    static func createPaymentHash(signature: String) -> String {
        debugPrint("hash contents: \(signature)")
        let data = Data(signature.bytes)
        let hash = data.sha512().toHexString().lowercased()
        
        return hash
    }
}
