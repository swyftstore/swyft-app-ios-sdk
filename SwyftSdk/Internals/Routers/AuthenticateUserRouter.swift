//
//  AuthenticateUserRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseCore
import FirebaseAuth

internal class AuthenticateUserRouter {
    
    // MARK: Singleton
    static let shared = AuthenticateUserRouter()
    private init() {}
    
    // MARK: Data
    private var swyftId: String!
    private var qrCodeColor: UIColor!
    private var customAuth: String?
    private var success: SwyftAuthenticateUserCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ swyftId: String, _ qrCodeColor: UIColor, _ customAuth: String? = nil, _ success: @escaping SwyftAuthenticateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.swyftId = swyftId
        self.qrCodeColor = qrCodeColor
        self.customAuth = customAuth
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.checkFirebaseUser()
        }
    }
}

// MARK: Internals
private extension AuthenticateUserRouter {
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.authenticateUserSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        
        getToken()
    }
    
    
    private func getToken() {
        
        Configure.current.session?.sdkFirebaseUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            
            if let _ = error {
                report(.authenticateUserAccessTokenFailure, self.failure)
                return
            }
            
            guard let idToken = idToken else {
                report(.authenticateUserNoAccessToken, self.failure)
                return
            }
            
            self.customerAuth(idToken)
        })
    }
    
    private func customerAuth(_ idToken: String) {
        
        SdkUserAuthInteractor.userAuth(swyftId: swyftId, idToken: idToken, customAuth: customAuth, success: { response in
            
            if let validCustomAuth = self.customAuth {
                
                let token = validCustomAuth
                
                guard let newQRCode = SwyftImageGenerator.buildQRImage(string: token, color: self.qrCodeColor) else {
                    report(.authenticateUserQRCodeFailure, self.failure)
                    return
                }
                
                let result = SwyftAuthenticateUserResponse(qrCode: newQRCode)
                self.callSuccess(using: result)
                
            } else {
                self.getUserAuthentication(response.payload.authToken)
            }
            
        }) { error in
            report(.authenticateUserSdkCustomerAuthFailure, self.failure)
        }
    }
    
    private func getUserAuthentication(_ authToken: String) {
        
        Auth.auth(app: Configure.fireBaseApp).signIn(withCustomToken: authToken) { result, error in
            
            if let _ = error {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.authenticateUserFirebaseSignInFailure, self.failure)
                return
            }
            
            guard let result = result else {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.authenticateUserNoFirebaseSignIn, self.failure)
                return
            }
            
            Configure.current.session?.clientFirebaseUser = result.user
            
            result.user.getIDTokenForcingRefresh(true, completion: { idToken, error in
                
                if let _ = error {
                    report(.authenticateUserAccessTokenFailure, self.failure)
                    return
                }
                
                guard let idToken = idToken else {
                    report(.authenticateUserNoAccessToken, self.failure)
                    return
                }
                
                guard let newQRCode = SwyftImageGenerator.buildQRImage(string: idToken, color: self.qrCodeColor) else {
                    report(.authenticateUserQRCodeFailure, self.failure)
                    return
                }
                
                let result = SwyftAuthenticateUserResponse(qrCode: newQRCode)
                self.callSuccess(using: result)
            })
        }
    }
    
    private func callSuccess(using response: SwyftAuthenticateUserResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
