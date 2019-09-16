//
//  SdkEnrollRequest.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

struct SdkEnrollRequest: Codable {
    let key: String
    let id: String
    let idToken: String
    let customer: SdkEnrollCustomerRequest
}

struct SdkEnrollCustomerRequest: Codable {
    let emailAddress: String
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    
    init(emailAddress: String, firstName: String?, lastName: String?, phoneNumber: String?) {
        self.emailAddress = emailAddress
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
