//
//  SdkErrorResponse.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 9/19/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

internal struct SdkErrorResponse: Codable {
    let error: String
    let message: String
    let success: Bool
}
