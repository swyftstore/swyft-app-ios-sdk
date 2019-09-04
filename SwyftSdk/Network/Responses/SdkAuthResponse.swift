//
//  SdkAuthResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

struct SdkAuthResponse: Codable {
    let success: Bool
    let message: String
    let payload: SdkAuthPayloadResponse
}

struct SdkAuthPayloadResponse: Codable {
    let authToken: String
    let roles: SdkAuthRolesResponse
    let merchantNames: [String: String]
    let categories: [String]
}

struct SdkAuthRolesResponse: Codable {
    let swyftSdkClient: Bool
}
