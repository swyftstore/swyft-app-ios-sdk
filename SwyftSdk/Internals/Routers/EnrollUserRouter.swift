//
//  EnrollUserRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class EnrollUserRouter {
    
    // MARK: Singleton
    static let shared = EnrollUserRouter()
    private init() {}
    
    // MARK: Data
    private var user: SwyftUser!
    private var success: SwyftEnrollUserCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ user: SwyftUser, _ success: @escaping SwyftEnrollUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
        // Save all parameters for later use
        self.user = user
        self.success = success
        self.failure = failure
        
        DispatchQueue.global(qos: .background).async {
            self.validateData()
        }
    }
}

// MARK: Internals
private extension EnrollUserRouter {
    
    private func validateData() {
        
        guard user.email.count > 0 else {
            report(.enrollUserInvalidUserEmail, failure)
            return
        }
        
        if let firstName = user.firstName {
            guard firstName.count > 0 else {
                report(.enrollUserInvalidUserFirstName, failure)
                return
            }
        }
        
        if let lastName = user.lastName {
            guard lastName.count > 0 else {
                report(.enrollUserInvalidUserLastName, failure)
                return
            }
        }
        
        if let phoneNumber = user.phoneNumber {
            guard phoneNumber.count > 0 else {
                report(.enrollUserInvalidUserPhone, failure)
                return
            }
        }
        
        checkFirebaseUser()
    }
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.sdkFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.enrollUserSdkNotInitialized, failure)
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
                report(.enrollUserAccessTokenFailure, self.failure)
                return
            }
            
            guard let idToken = idToken else {
                report(.enrollUserNoAccessToken, self.failure)
                return
            }
            
            self.enroll(idToken)
        })
    }
    
    private func enroll(_ idToken: String) {
        
        SdkEnrollInteractor.enroll(customerInfo: user, idToken: idToken, success: { response in
            
            Configure.current.session?.sdkAuthToken = response.payload.authToken
            
            let result = SwyftEnrollUserResponse(message: response.message, swyftId: response.payload.swyftId, authToken: response.payload.authToken)
            self.callSuccess(using: result)
            
        }) { error in
            report(.enrollUserSdkEnrollFailure, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftEnrollUserResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
