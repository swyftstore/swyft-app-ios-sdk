//
//  CreateUserProfile.swift
//  customer
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwyftSdk

protocol CreateCustomerDelegate: class {
    func createCustSuccess(id: String)
    func createCustFail(msg: String)
}

class CreateCustomer: NSObject {
    var updateCustomer: SwyftSdk.UpdateCustomer?
    var customer: Customer?
    var delegate: CreateCustomerDelegate?
    
    init(delegate: CreateCustomerDelegate) {
        super.init()        
        self.delegate = delegate;
        
        self.updateCustomer = SwyftSdk.UpdateCustomer(success: { (msg, id) in
            if let id = id {
                self.delegate?.createCustSuccess(id: id)
            }
        }, fail: { (msg) in
            self.delegate?.createCustFail(msg: msg)
        })
    }
    
    func createCustomerProfile(id: String?, customer: Customer){
        let data = customer.deserialize()
        updateCustomer?.add(key: id, data: data)
    }
    
    func createCustomer(user: User, signInMethod: String) {
        let customer = Customer()
        let userId = user.uid
        if let displayName = user.displayName {
            let names = Utils.getFirstAndLastName(fullName: displayName)
            customer.firstName = names[0]
            customer.lastName = names[1]
        }
        customer.emailAddress = user.email
        customer.logInCounter = 0
        customer.status = "created"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let dateString = formatter.string(from: Date())
        customer.createdOn = dateString
        customer.lastLogIn = dateString
        customer.signInMethod = signInMethod;
        self.createCustomerProfile(id: userId, customer: customer)
        
    }
    
    func createCustomer(firstName: String, lastName: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let _self = self else { return }
            
            if let error = error {
                debugPrint(error)
                let msg = NSLocalizedString("SignUpDuplicateUserError", comment: "")
                _self.delegate?.createCustFail(msg: msg)
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = "\(firstName) \(lastName)"
                changeRequest?.commitChanges { (error) in
                    if let error = error {
                        debugPrint(error)
                         let msg = NSLocalizedString("SignUpGeneralError", comment: "")
                        _self.delegate?.createCustFail(msg: msg)
                    } else {
                        if let user = Auth.auth().currentUser {
                            _self.createCustomer(user: user, signInMethod: Constants.EmailPassword)
                        }
                    }
                }
            }
        }
        
    }
    
    
}
