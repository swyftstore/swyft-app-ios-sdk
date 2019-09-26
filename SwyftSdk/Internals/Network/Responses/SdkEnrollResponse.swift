//
//  SdkEnrollResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/4/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal class SdkEnrollResponse: Codable {
    let success: Bool
    let message: String
    let payload: SdkEnrollPayLoadResponse
}

internal struct SdkEnrollPayLoadResponse: Codable {
    let swyftId: String
    let authToken: String
}
