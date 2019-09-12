//
//  EnrollUserPresenter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

class EnrollUserPresenter {
    
    // MARK: Singleton
    static let shared = EnrollUserPresenter()
    private init() {}
    
    func execute(_ user: SwyftUser, _ success: @escaping SwyftEnrollCallback, _ failure: @escaping SwyftFailureCallback) {
        
        guard let _ = Configure.current.session?.sdkFirebaseUser else {
            // TODO: we should implement an auto retry
            let error = SwyftError.enrollUserSdkNotInitialized.build()
            debugPrint(error)
            failure(error)
            return
        }
        
        guard user.email.count > 0 else {
            let error = SwyftError.enrollUserInvalidUserEmail.build()
            debugPrint(error)
            failure(error)
            return
        }
        
        if let firstName = user.firstName {
            guard firstName.count > 0 else {
                let error = SwyftError.enrollUserInvalidUserFirstName.build()
                debugPrint(error)
                failure(error)
                return
            }
        }
        
        if let lastName = user.lastName {
            guard lastName.count > 0 else {
                let error = SwyftError.enrollUserInvalidUserLastName.build()
                debugPrint(error)
                failure(error)
                return
            }
        }
        
        if let phoneNumber = user.phoneNumber {
            guard phoneNumber.count > 0 else {
                let error = SwyftError.enrollUserInvalidUserPhone.build()
                debugPrint(error)
                failure(error)
                return
            }
        }
        
        getToken(user, success, failure)
    }
    
    private func getToken(_ user: SwyftUser, _ success: @escaping SwyftEnrollCallback, _ failure: @escaping SwyftFailureCallback) {
        
        Configure.current.session?.sdkFirebaseUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            
            if let _ = error {
                let error = SwyftError.enrollUserAccessTokenFailure.build()
                debugPrint(error)
                failure(error)
                return
            }
            
            guard let idToken = idToken else {
                let error = SwyftError.enrollUserNoAccessToken.build()
                debugPrint(error)
                failure(error)
                return
            }
            
            self.enroll(idToken: idToken, user, success, failure)
        })
    }
    
    private func enroll(idToken: String, _ user: SwyftUser, _ success: @escaping SwyftEnrollCallback, _ failure: @escaping SwyftFailureCallback) {
        
        SdkEnrollInteractor.enroll(customerInfo: user, idToken: idToken, success: { response in
            
            Configure.current.session?.sdkAuthToken = response.payload.authToken
            
            let result = SwyftEnrollResponse(message: response.message, swyftId: response.payload.swyftId, authToken: response.payload.authToken)
            success(result)
            
        }) { error in
            
            let error = SwyftError.enrollUserSdkEnrollFailure.build()
            debugPrint(error)
            failure(error)
        }
    }
}
