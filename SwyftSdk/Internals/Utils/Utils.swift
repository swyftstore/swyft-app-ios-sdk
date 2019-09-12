//
//  Utils.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/7/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Moya

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
    
    static func getPaymentURL() -> URL? {
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
    
    static func getSdkAuthKey() -> String? {
        
        guard let url = Bundle.main.url(forResource:"Info", withExtension: "plist") else {
            debugPrint("Swyft SDK: No Info.plist file")
            return nil
        }
        
        let data: Data
        do {
            data = try Data(contentsOf:url)
        } catch {
            debugPrint(error)
            return nil
        }
        
        let infoPlist: [String:Any]
        do {
            infoPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
        } catch {
            debugPrint(error)
            return nil
        }
        
        guard let key = infoPlist["SWYFT_SDK_AUTH_KEY"] as? String else {
            debugPrint("Swyft SDK: Missing Info.plist property")
            return nil
        }
        
        return key
    }
    
    static func getPaymentDateTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY:HH:mm:ss:SSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    static func createPaymentHash(signature: String) -> String {
        let data = Data(signature.bytes)
        let hash = data.sha512().toHexString().lowercased()
        
        return hash
    }
    
    static func getMockData(fileName: String) -> [String: [String:Any]]? {
        var json: [String: [String:Any]]?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: [])
                let str = String(data: data, encoding: .utf8)
                json = mockDataHelper(data:data)
            } catch {
                // Handle error here
            }
        }
        return json
    }
    
    static private func mockDataHelper(data: Data) -> [String: [String:Any]]? {
        var jsonMap: [String: [String:Any]]?
        jsonMap = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: [String:Any]]
        print(jsonMap!)
    
        return jsonMap
    }
    
    static func getJsonString(from response: Moya.Response) -> String? {
        
        let jsonString: String
        
        do {
            jsonString = try response.mapString()
            
        } catch {
            debugPrint(error)
            return nil
        }
        
        return jsonString
    }
}