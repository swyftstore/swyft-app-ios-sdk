//
//  FirebaseOptions.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 9/25/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import CryptoSwift

internal class SwyftOptions {
    
    public static let clientIDKey = "clientID"
    public static let gcmSenderIDKey = "gcmSenderID"
    public static let apiKeyKey = "apiKey"
    public static let projectIDKey = "projectID"
    public static let googleAppIDKey = "googleAppID"
    public static let bundleIDKey = "bundleID"
    public static let storageBucketKey = "storageBucket"
    public static let databaseURLKey = "databaseURL"
    
    private var options = [String:[String:Array<UInt8>]]()
    private var pw = [String: String]()
    private let dev = "dev"
    private let qa = "qa"
    private let prod = "prod"
    private let iv = "52lV4RkAMCIEf4c1"
    
    init() {
        //pw[qa] = "o4xllsExmomaMTyr"
        //pw[prod] = "Y2FgtowxZ4VzXQ2u"
        options[dev] = [String: Array<UInt8>]()
        options[qa] = [String: Array<UInt8>]()
        options[prod] = [String: Array<UInt8>]()
        buildDevOptions()
    }
    
    func addOption(env: String, key: String, value: String?, pwd: String) {
        
        guard var optValue = options[env],
            let value = value  else {
            print("Invalid environment")
            return;
        }
       
        do {
           
            let aes = try AES(key: pwd, iv: iv) // aes128
            let ciphertext = try aes.encrypt(Array(value.utf8))
            optValue[key] = ciphertext
            debugPrint("\(key): \(ciphertext)")
        } catch {
            print("Could not encrypt value")
        }
      
    }
    
    func getOption(env: String, key: String, pwd: String) -> String? {
        
        guard let encryptedData = options[env]?[key] else {
            print("Invalid environment")
            return nil
        }
        
        do {
            let aes = try AES(key: pwd, iv: iv)
            let decryptedValue = try aes.decrypt(encryptedData)
            return String(bytes: decryptedValue, encoding: .utf8)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func buildDevOptions() {
        
        let clientID: Array<UInt8> = [34, 198, 84, 195, 6, 182, 26, 203, 160, 175, 96, 230, 109, 160, 24, 213, 33, 156, 68, 154, 186, 192, 190, 187, 215, 18, 162, 206, 53, 240, 140, 232, 133, 20, 117, 36, 0, 90, 97, 102, 20, 253, 111, 195, 166, 26, 99, 160, 150, 0, 135, 142, 48, 100, 198, 104, 127, 91, 74, 197, 246, 110, 91, 200, 2, 246, 157, 4, 6, 244, 61, 90, 2, 105, 57, 226, 77, 84, 130, 245]
        let gcmSenderID: Array<UInt8> = [224, 202, 248, 192, 48, 11, 56, 69, 209, 171, 178, 241, 40, 177, 79, 183]
        let apiKey: Array<UInt8> = [97, 181, 178, 156, 173, 106, 54, 194, 91, 227, 14, 244, 155, 199, 44, 34, 216, 147, 101, 0, 162, 6, 200, 91, 14, 91, 99, 88, 60, 200, 92, 160, 82, 47, 107, 200, 136, 161, 176, 242, 198, 214, 11, 252, 248, 54, 162, 97]
        let projectID: Array<UInt8> = [180, 49, 225, 208, 228, 102, 168, 232, 70, 200, 11, 155, 19, 248, 129, 114]
        let googleAppID: Array<UInt8> = [160, 29, 184, 241, 177, 74, 224, 83, 168, 202, 48, 77, 235, 224, 173, 209, 202, 186, 119, 58, 27, 191, 208, 38, 126, 180, 156, 134, 245, 173, 12, 1, 115, 125, 100, 184, 148, 190, 64, 108, 49, 128, 104, 228, 167, 205, 181, 119]
        let bundleID: Array<UInt8> = [118, 153, 82, 197, 91, 77, 56, 204, 139, 67, 41, 36, 180, 29, 16, 117, 83, 173, 155, 131, 195, 216, 81, 216, 71, 186, 151, 8, 204, 189, 42, 14]
        let storageBucket: Array<UInt8> = [205, 199, 94, 102, 25, 15, 58, 147, 44, 60, 77, 80, 91, 226, 5, 201, 153, 225, 170, 204, 50, 121, 131, 149, 135, 240, 236, 157, 228, 108, 219, 211]
        let databaseURL: Array<UInt8> = [114, 253, 117, 184, 143, 248, 25, 116, 182, 119, 121, 53, 119, 54, 231, 192, 243, 135, 186, 39, 15, 189, 66, 65, 154, 14, 194, 203, 64, 208, 228, 32, 197, 137, 236, 255, 238, 54, 210, 134, 136, 142, 206, 127, 180, 154, 205, 118]
        
        
        options[dev]![SwyftOptions.clientIDKey] = clientID
        options[dev]![SwyftOptions.gcmSenderIDKey] = gcmSenderID
        options[dev]![SwyftOptions.apiKeyKey] = apiKey
        options[dev]![SwyftOptions.projectIDKey] = projectID
        options[dev]![SwyftOptions.googleAppIDKey] = googleAppID
        options[dev]![SwyftOptions.bundleIDKey] = bundleID
        options[dev]![SwyftOptions.storageBucketKey] = storageBucket
        options[dev]![SwyftOptions.databaseURLKey] = databaseURL

        
    }
    
}
