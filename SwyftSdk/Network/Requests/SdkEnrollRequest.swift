//
//  SdkEnrollRequest.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

public struct SdkEnrollRequest: Codable {
    let key: String
    let id: String
    let idToken: String
    let customer: SdkEnrollCustomerRequest
}

public struct SdkEnrollCustomerRequest: Codable {
    let emailAddress: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
}
