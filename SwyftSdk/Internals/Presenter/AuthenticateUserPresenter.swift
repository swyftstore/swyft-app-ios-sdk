//
//  AuthenticateUserPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class AuthenticateUserPresenter {
    
    // MARK: Singleton
    static let shared = AuthenticateUserPresenter()
    private init() {}
    
    func execute(_ swyftId: String, _ qrCodeColor: UIColor, _ customAuth: String? = nil, _ success: SwyftAuthenticateUserCallback, _ failure: SwyftFailureCallback) {
        
    }
}
