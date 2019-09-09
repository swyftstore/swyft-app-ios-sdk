//
//  CustomerInfo.swift
//  ActionSheetPicker-3.0
//
//  Created by Rigoberto Saenz Imbacuan on 9/9/19.
//

public struct CustomerInfo: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    //let dateOfBirth: String?
    
    public init(email: String, firstName: String, lastName: String, phoneNumber: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
