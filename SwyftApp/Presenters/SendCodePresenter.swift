//
//  SendCodePresenter.swift
//  customer
//
//  Created by Tom Manuel on 5/20/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

protocol SendCodeProtocol: BaseViewProtocol {
    var codeInputField: UITextField? { get }
    var presenter: SendCodePresenter? { get }
    func success(msg: String, segue: String?)
    func failure(msg: String)
    func validation() -> Bool
    func handleNext()
}

class SendCodePresenter: BasePresenter {
    
    weak var delegate: SendCodeProtocol?
    var updateCustomer: UpdateCustomer?

    
    init(delegate: SendCodeProtocol) {
        super.init()
        self.delegate = delegate
        self.delegate?.codeInputField?.delegate = self
        self.updateCustomer = UpdateCustomer(delegate: self)
        if let _ = Session.currentSession.customer?.activationCode { } else {
            resendCodeHandler()
        }
    }
    
    func sendActivationCodeHandler(code: String) {
        if let _code = Session.currentSession.customer?.activationCode,
            let id = Session.currentSession.customer?.id {
            if code == _code {
                var data = [String: Any]()
                data[Constants.ActivationCode] = FieldValue.delete()
                data[Constants.Status] = "active"
                data[Constants.LogInCounter] = 1
                let date = Date()
                data[Constants.LastLogIn] = Utils.getIsoDateString(date: date)
                updateCustomer?.updateCustomer(id: id, data: data)
            } else {
                let msg = NSLocalizedString("SendCodeError", comment: "")
                self.delegate?.failure(msg: msg)
            }
        }
    }
    
    func resendCodeHandler() {
        if let id = Session.currentSession.customer?.id {
            let random = Utils.createRandomNumberString(length: 6)
            let updateCustomer = UpdateCustomer(delegate: self)

            var data = [String:Any]()
            data[Constants.ActivationCode] = random
            updateCustomer.updateCustomer(id: id, data: data)
        } else {
            let msg = NSLocalizedString("SendCodeGeneralError", comment: "")
            self.delegate?.failure(msg: msg)
        }
    }
    
    // MARK: - format validator
    private func checkPhoneNumberFormat(replacementString: String?, str: String?) -> Bool {
        
        //BackSpace
        if let codeInputField = self.delegate?.codeInputField {
            if str!.count <= 1 {
                return true
            } else if replacementString!.count == 0,
                let _str = str {
                codeInputField.text = _str
            }
            else if str!.count > 11 {
                return false
            }
            else {
                codeInputField.text = "\(codeInputField.text!)-"
            }
        }
        return true
    }
    
    private func formatWholeNumber(string: String) -> Bool {
        
        if let codeInputField = self.delegate?.codeInputField  {
            var newText = "";
            if let text = codeInputField.text {
                for (offset, char) in text.enumerated() {
                    if (offset < 11) {
                        newText.append(char)
                        newText.append("-")
                    } else {
                        newText.append(char)
                    }
                }
            }
            codeInputField.text = newText;
        }
        return false
    }
}

extension SendCodePresenter: UpdateCustomerDelegate {
    func updateCustSuccess(id: String) {
        self.delegate?.success(msg: "customer activated", segue: "MainSegue")
    }
    
    func updateCustFail(msg: String) {
        let msg = NSLocalizedString("SendCodeGeneralError", comment: "")
        self.delegate?.failure(msg: msg)
    }
}

extension SendCodePresenter: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 3, !string.contains("-") {
            return self.formatWholeNumber(string: string)
        } else {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return self.checkPhoneNumberFormat(replacementString: string, str: str)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            self.delegate?.handleNext()
        }
        // Do not add a line break
        return false
    }
}
