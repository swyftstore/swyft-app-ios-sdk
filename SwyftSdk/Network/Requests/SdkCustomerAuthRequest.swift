//
//  SdkCustomerAuthRequest.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/9/19.
//

public struct SdkCustomerAuthRequest: Codable {
    let key: String
    let id: String
    let swyftId: String
    let idToken: String
    let customAuth: String?
}
