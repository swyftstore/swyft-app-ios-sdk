//
//  utils.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
   static func getFirstAndLastName(fullName: String) ->[String] {
        var  fnLName: [String] = []
        var names = fullName.components(separatedBy: " ")
        
        let lastName = names.popLast()
        var firstName = ""
        
        for name in names {
            firstName.append("\(name) ")
        }
        firstName = String(firstName.dropLast())
        
        if let lastName = lastName {
           fnLName.append(firstName)
           fnLName.append(lastName)          
        }
        return fnLName
    }
    
    static func createRandomNumberString(length: Int) -> String {
        var randomString = ""
        
        for _ in 1...length {
            let num = Int.random(in: 0..<10)
            randomString.append(String(num))
        }
        return randomString
       
    }
    
    static func getIsoDateString(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    static func addFloatingPlacehoolder(textField: UITextField) {
//        let floatTextField = Constants.floatPlaceholderColor
//        floatTextField.placeholder = textField.pla
//        floatTextField.title = "Your full name"
//        textField.addSubview(textField)
    }
}
