//
//  SdkEnrollResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

struct SdkEnrollResponse: Codable {
    let success: String
    let message: String
    let payload: SdkEnrollPayLoadResponse
}

struct SdkEnrollPayLoadResponse: Codable {
    let swyftId: String
    let linkCredentials: Bool
    let authToken: String? // nil for New Users
}
