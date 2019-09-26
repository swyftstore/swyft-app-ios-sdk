//
//  SdkCustomerAuthResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/9/19.
//

internal struct SdkCustomerAuthResponse: Codable {
    let success: Bool
    let message: String
    let payload: SdkCustomerAuthPayloadResponse
}

internal struct SdkCustomerAuthPayloadResponse: Codable {
    let authToken: String
}
