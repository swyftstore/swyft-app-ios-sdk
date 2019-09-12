//
//  AuthenticateUserPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseCore
import FirebaseAuth

class AuthenticateUserPresenter {
    
    // MARK: Singleton
    static let shared = AuthenticateUserPresenter()
    private init() {}
    
    func execute(_ swyftId: String, _ qrCodeColor: UIColor, _ customAuth: String? = nil, _ success: @escaping SwyftAuthenticateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // TODO: we should implement an auto retry
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            report(.authenticateUserSdkNotInitialized, failure)
            return
        }
        
        getToken(swyftId, qrCodeColor, customAuth, success, failure)
    }
    
    
    private func getToken(_ swyftId: String, _ qrCodeColor: UIColor, _ customAuth: String? = nil, _ success: @escaping SwyftAuthenticateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        Configure.current.session?.sdkFirebaseUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            
            if let _ = error {
                report(.authenticateUserAccessTokenFailure, failure)
                return
            }
            
            guard let idToken = idToken else {
                report(.authenticateUserNoAccessToken, failure)
                return
            }
            
            self.customerAuth(swyftId, qrCodeColor, customAuth, idToken, success, failure)
        })
    }
    
    private func customerAuth(_ swyftId: String, _ qrCodeColor: UIColor, _ customAuth: String?, _ idToken: String, _ success: @escaping SwyftAuthenticateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        SdkCustomerAuthInteractor.customerAuth(swyftId: swyftId, idToken: idToken, customAuth: customAuth, success: { response in
            
            if let validCustomAuth = customAuth {
                
                let token = validCustomAuth
                
                guard let newQRCode = SwyftImageGenerator.buildQRImage(string: token, color: qrCodeColor) else {
                    report(.authenticateUserQRCodeFailure, failure)
                    return
                }
                
                let result = SwyftAuthenticateUserResponse(qrCode: newQRCode)
                success(result)
                
            } else {
                self.getUserAuthentication(qrCodeColor, response.payload.authToken, success, failure)
            }
            
        }) { error in
            report(.authenticateUserSdkCustomerAuthFailure, failure)
        }
    }
    
    private func getUserAuthentication(_ qrCodeColor: UIColor, _ authToken: String, _ success: @escaping SwyftAuthenticateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        Auth.auth(app: Configure.fireBaseApp).signIn(withCustomToken: authToken) { result, error in
            
            if let _ = error {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.authenticateUserFirebaseSignInFailure, failure)
                return
            }
            
            guard let result = result else {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.authenticateUserNoFirebaseSignIn, failure)
                return
            }
            
            result.user.getIDTokenForcingRefresh(true, completion: { idToken, error in
                
                if let _ = error {
                    report(.authenticateUserAccessTokenFailure, failure)
                    return
                }
                
                guard let idToken = idToken else {
                    report(.authenticateUserNoAccessToken, failure)
                    return
                }
                
                guard let newQRCode = SwyftImageGenerator.buildQRImage(string: idToken, color: qrCodeColor) else {
                    report(.authenticateUserQRCodeFailure, failure)
                    return
                }
                
                let result = SwyftAuthenticateUserResponse(qrCode: newQRCode)
                success(result)
            })
        }
    }
}

