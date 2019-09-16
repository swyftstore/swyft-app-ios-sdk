//
//  SwyftEnrollUserResponse.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

public struct SwyftEnrollUserResponse: Codable {
    public let message: String
    public let swyftId: String
    public let authToken: String
}
