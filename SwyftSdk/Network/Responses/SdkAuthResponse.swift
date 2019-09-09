//
//  SdkAuthResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

public struct SdkAuthResponse: Codable {
    let success: Bool
    let message: String
    let payload: SdkAuthPayloadResponse
}

public struct SdkAuthPayloadResponse: Codable {
    let authToken: String
    let roles: SdkAuthRolesResponse
    let merchantNames: [String: String]
    let categories: [String]
}

public struct SdkAuthRolesResponse: Codable {
    let swyftSdkClient: Bool
}
