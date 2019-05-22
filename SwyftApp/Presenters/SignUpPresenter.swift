//
//  SignUpPresenter.swift
//  customer
//
//  Created by Tom Manuel on 5/20/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation

protocol SignUpProtocol: BaseViewProtocol {
    var presenter: SignUpPresenter? {get}
    func success(msg: String, segue: String?)
    func failure(msg: String)
    func validation() -> Bool
}

class SignUpPresenter: BasePresenter {
    
    weak var delegate: SignUpProtocol?
    
    init(delegate: SignUpProtocol) {
        super.init()
        self.delegate = delegate;
    }
    
    func signUpHandler(email: String, password: String, firstName: String, lastName: String) {
        let msg = NSLocalizedString("SigningUp", comment: "")
        if let _delegate = delegate {
            _delegate.showLoadingHud(message: msg)
            if _delegate.validation() {
                let createCustomer = CreateCustomer(delegate: self)
                createCustomer.createCustomer(firstName: firstName, lastName: lastName,
                                          email: email, password: password)
            }
        }
    }
}


extension SignUpPresenter: CreateCustomerDelegate {
    func createCustSuccess(id: String) {
        self.delegate?.success(msg: "user created", segue: "AddPhoneNumberSegue")
    }
    
    func createCustFail(msg: String) {
        debugPrint(msg)
        self.delegate?.failure(msg: msg)
    }
}
