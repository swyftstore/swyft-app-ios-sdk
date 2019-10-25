//
//  UpdateUserRouter.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 10/14/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseAuth

internal class UpdateUserRouter {
    
    // MARK: Singleton
    static let shared = UpdateUserRouter()
    private init() {}
    
    // MARK: Data
    private var user: SwyftUser!
    private var success: SwyftUpdateUserCallback!
    private var failure: SwyftFailureCallback!
    
    // MARK: Actions
    func route(_ user: SwyftUser, _ success: @escaping SwyftUpdateUserCallback, _ failure: @escaping SwyftFailureCallback) {
        
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
private extension UpdateUserRouter {
    
    private func validateData() {
        
        guard user.email.count > 0 else {
            report(.updateUserInvalidUserEmail, failure)
            return
        }
        
        if let firstName = user.firstName {
            guard firstName.count > 0 else {
                report(.updateUserInvalidUserFirstName, failure)
                return
            }
        }
        
        if let lastName = user.lastName {
            guard lastName.count > 0 else {
                report(.updateUserInvalidUserLastName, failure)
                return
            }
        }
        
        if let phoneNumber = user.phoneNumber {
            guard phoneNumber.count > 0 else {
                report(.updateUserInvalidUserPhone, failure)
                return
            }
        }
        
        checkFirebaseUser()
    }
    
    private func checkFirebaseUser() {
        
        var iteration = 0
        while (true) {
            
            if let _ = Configure.current.session?.clientFirebaseUser {
                break
                
            } else if iteration > SwyftConstants.RouterMaxRetries {
                report(.updateUserSdkNotInitialized, failure)
                return
            }
            
            iteration += 1
            usleep(UInt32(SwyftConstants.RouterWaitBetweenRetries))
        }
        guard let uid = Configure.current.session?.clientFirebaseUser?.uid else {
            report(.updateUserSdkNotInitialized, failure)
            return
        }
        update(uid)
    }
    
    
    private func update(_ id: String) {
        let getCustomer = GetCustomer(success:
        { (data) in
            var updateFBAuth = false
            guard let customer = data as? Customer else {
                report(.updateUserSdkUpdateFailure, self.failure)
                return
            }
            if let firstName = self.user.firstName {
                customer.firstName = firstName
            }
            if let lastName = self.user.lastName {
                customer.lastName = lastName
            }
            if customer.phoneNumber != self.user.phoneNumber {
                customer.phoneNumber = self.user.phoneNumber
            }
            if customer.emailAddress != self.user.email {
                customer.emailAddress = self.user.email
                updateFBAuth = true
            }
                                   
            if (updateFBAuth) {
                self.updateAuth(customer)
            } else {
                self.updateDB(customer)
            }
         }) { (error) in
            print(error)
            report(.updateUserSdkUpdateFailure, self.failure)
         }
         getCustomer.get(id: id)
    }
    
    private func updateDB(_ customer: Customer) {
        let updateCustomer = UpdateCustomer(success: { (msg, id) in
            let updateResult = SwyftUpdateUserResponse(message: msg)
             self.callSuccess(using: updateResult)
        }) { (error) in
            print(error)
            report(.updateUserSdkUpdateFailure, self.failure)
        }
        
        updateCustomer.put(key: customer.id!, customer: customer)
    }
    
    private func updateAuth(_ customer: Customer) {
        DispatchQueue.global(qos: .background).async {
            guard let sdkFBUser = Configure.current.session?.sdkFirebaseUser,
                let clientFBUser = Configure.current.session?.clientFirebaseUser else {
                report(.updateUserSdkUpdateFailure, self.failure)
                return
            }
            
           
            
            guard let email = customer.emailAddress else {
                report(.updateUserSdkUpdateFailure, self.failure)
                return
            }
            
            if let fn = customer.firstName, let ln = customer.lastName,
                "\(fn) \(ln)" != clientFBUser.displayName {
                let changeRequest = clientFBUser.createProfileChangeRequest()
                changeRequest.displayName = "\(fn) \(ln)"
                changeRequest.commitChanges(completion: { (error) in
                    if let _ = error {
                        debugPrint("Swyft SDK Update User: Unable to update user's firebase auth profile")
                        //report(.updateUserSdkUpdateFailure, self.failure)
                    }
                })
            }
            
            sdkFBUser.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                
                if let _ = error {
                    report(.updateUserAccessTokenFailure, self.failure)
                    return
                }
                
                guard let idToken = idToken else {
                    report(.updateUserNoAccessToken, self.failure)
                    return
                }
                
                self.customerReAuth(idToken, customer, email)
            })
           
            
        }
        
    }
    
    private func customerReAuth(_ idToken: String, _ customer: Customer, _ email: String) {
        
        guard let fbUser = Configure.current.session?.clientFirebaseUser, let swyftId = customer.id else {
            report(.updateUserSdkUpdateFailure, self.failure)
            return
        }
        
        SdkUserAuthInteractor.userAuth(swyftId: swyftId, idToken: idToken, success: { response in
            
            fbUser.updateEmail(to: email) { (error) in
                if let error = error {
                    print(error)
                    report(.updateUserInvalidUserEmail, self.failure)
                    return
                } else {
                    self.updateDB(customer)
                }
            }
            
        }) { error in
            report(.authenticateUserSdkCustomerAuthFailure, self.failure)
        }
    }
    
    private func callSuccess(using response: SwyftUpdateUserResponse) {
        DispatchQueue.main.async {
            self.success(response)
        }
    }
}
