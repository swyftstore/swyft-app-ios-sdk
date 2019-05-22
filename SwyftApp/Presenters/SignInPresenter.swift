//
//  SignInPresenter.swift
//  customer
//
//  Created by Tom Manuel on 5/16/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwyftSdk

protocol SignInProtocol: BaseViewProtocol {
    var presenter: SignInPresenter? {get}
    func success(msg: String, segue: String?)
    func failure(msg: String)
    func validation() ->Bool
}

class SignInPresenter: BasePresenter {
    weak var delegate: SignInProtocol?
    
    init(delegate: SignInProtocol) {
        super.init()
        self.delegate = delegate;
    }
    
    func signInHandler(email: String, password: String) {
        let msg = NSLocalizedString("SigningIn", comment: "")
        self.delegate?.showLoadingHud(message: msg)
        if let _delegate = self.delegate, _delegate.validation() {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] fbSession, error in
                guard let  _self = self else { return }
                
                if let error = error {
                    debugPrint(error)
                    _self.delegate?.hideLoadingHud()

                    let msg = NSLocalizedString("InvalidCreds", comment: "")
                    _self.delegate?.failure(msg: msg)
                    return
                }
                
                let getCustomer = GetCustomer( delegate: _self)
                let session = Session.currentSession
                session.fbSession = fbSession
                session.signInMethod = Constants.EmailPassword
                
                if let user = fbSession?.user, let email = user.email {
                    getCustomer.getCustomer(email: email)
                }
                
            }
        }
    }
    
    func loadCustomerHandler(user: User) {
        let msg = NSLocalizedString("SigningIn", comment: "")
        delegate?.showLoadingHud(message: msg)
        let getCustomer = GetCustomer(delegate:self)
        if let email = user.email {
            getCustomer.getCustomer(email: email)
        } else {
            getCustomer.getCustomer(id: user.uid)
        }
    }
    
    func loadCustomerHandler(user: User, signInMethod: String) {
        Session.currentSession.signInMethod = signInMethod
        let getCustomer = GetCustomer(delegate:self)
        if let email = user.email {
            getCustomer.getCustomer(email: email)
        } else {
            getCustomer.getCustomer(id: user.uid)
        }
    }
    
    func createCustomer() {
        if let fbSession = Session.currentSession.fbSession {
            let user = fbSession.user
            let createCustomer = CreateCustomer(delegate: self)
            createCustomer.createCustomer(user: user, signInMethod: Constants.Google)
        }
    }
    
    private func updateCustomer(customer: Customer) {
        customer.logInCounter = customer.logInCounter.advanced(by: 1)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let dateString = formatter.string(from: Date())
        customer.lastLogIn = dateString
        if let signInMethod =  Session.currentSession.signInMethod {
            customer.signInMethod = signInMethod
        }
        var id: String?
        if let _id = Session.currentSession.customer?.id {
            id = _id
        }  else if let _id = Session.currentSession.fbSession?.user.uid {
            id = _id
            if let customer = Session.currentSession.customer {
                customer.id = _id
            }
        }
        
        if let id = id {
            let updateCustomer = UpdateCustomer(delegate: self)
            updateCustomer.updateCustomer(id: id, customer: customer)
        }
    }
    
    private func updateCustomerWDict(customer: Customer) {
        var data : Dictionary<String, Any> = [:];
        
        data[Constants.LogInCounter] = customer.logInCounter.advanced(by: 1)
        let date = Date()
        data[Constants.LastLogIn] = Utils.getIsoDateString(date: date)
        
        let id = Session.currentSession.fbSession?.user.uid
        if let id = id {
            let updateCustomer = UpdateCustomer(delegate: self)
            updateCustomer.updateCustomer(id: id, data: data)
        }
        
        
    }

}

extension SignInPresenter: GetCustomerDelegate {
    func getCustomerFail(msg: String) {
         self.delegate?.hideLoadingHud()
        debugPrint(msg)
        createCustomer()
    }
    
    func getCustomerSuccess(customer: Customer?) {
        if let customer = customer, customer.status != "inactive" {
            let session = Session.currentSession
            self.delegate?.hideLoadingHud()
            session.customer = customer
            if let _ = customer.phoneNumber {
                if customer.status == "active" {
                    updateCustomer(customer: customer)
                    self.delegate?.success(msg: "Signed In Successfully", segue: "MainSegue")
                } else {
                     self.delegate?.success(msg: "Going to Send Code View", segue: "SendCodeSegue")
                }
            } else {
                //to do add phone number
                self.delegate?.success(msg: "Going to Add Phone Number View", segue: "AddPhoneNumberSegue")
            }
            
        } else {
            let msg = NSLocalizedString("AccountNotActive", comment: "")
            self.delegate?.failure(msg: msg)
            debugPrint(msg)
        }
    }
}

extension SignInPresenter: CreateCustomerDelegate {
    
    func createCustSuccess(id: String) {
        debugPrint("customer created: ", id)
        let id = Session.currentSession.fbSession?.user.uid
        if let id = id {
            let getCustomer = GetCustomer(delegate: self)
            getCustomer.getCustomer(id: id)
        }
    }
    
    func createCustFail(msg: String) {
        self.delegate?.failure(msg: msg)
    }
}

extension SignInPresenter: UpdateCustomerDelegate {
    
    func updateCustFail(msg: String) {
        debugPrint(msg)
    }
    
    func updateCustSuccess(id: String) {
        debugPrint("customer updated: ", id)
    }
}
