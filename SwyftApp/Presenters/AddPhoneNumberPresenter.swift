//
//  AddPhoneNumberPresenter.swift
//  customer
//
//  Created by Tom Manuel on 5/20/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import UIKit

protocol AddPhoneNumberProtocol: BaseViewProtocol {
    var presenter: AddPhoneNumberPresenter? { get }
    var phoneNumberInput: UITextField? { get }

    func success(msg: String, segue: String?)
    func failure(msg: String)
    func validation() -> Bool
    func handleSendCode()
}

class AddPhoneNumberPresenter: BasePresenter {
    
    weak var delegate: AddPhoneNumberProtocol?
    
    init(delegate: AddPhoneNumberProtocol) {
        super.init()
        self.delegate = delegate
        self.delegate?.phoneNumberInput?.delegate = self
    }
    
    public func addNumberHandler(countryCode: String, phoneNumber: String) {
        
        if let _delegate = delegate {
            let msg = NSLocalizedString("AddPhoneNumberSendingSMS", comment: "")
            _delegate.showLoadingHud(message: msg)
            if _delegate.validation() {
                if let id = Session.currentSession.customer?.id {
                    
                    let updateCustomer = UpdateCustomer(delegate: self)
                    let random = Utils.createRandomNumberString(length: 6)
                    var data = [String:Any]()
                    
                    data[Constants.PhoneNumber] = "\(countryCode)-\(phoneNumber)"
                    data[Constants.ActivationCode] = random
                    updateCustomer.updateCustomer(id: id, data: data)
                }
            }
        }
    }
    
    // MARK: - format validator
    private func checkPhoneNumberFormat(replacementString: String?, str: String?) -> Bool {
        
        //BackSpace
        if let phoneNumberTextField = self.delegate?.phoneNumberInput {
            if replacementString == "" {
                return true
            }
            else if str!.count == 4 {
                phoneNumberTextField.text = phoneNumberTextField.text! + "-"
            }
            else if str!.count == 8 {
                phoneNumberTextField.text = phoneNumberTextField.text! + "-"
            }
            else if str!.count > 12 {
                return false
            }
        }
        return true
    }
    
    private func formatWholeNumber(string: String) -> Bool {
        
        if let phoneNumberTextField = self.delegate?.phoneNumberInput  {
            var newText : String = "";
            var offSet = 0;
            if (string.starts(with: "+1")) {
                offSet = 2;
            }
            if string.count > (2+offSet) {
                let lowerBound = string.index(string.startIndex, offsetBy: offSet)
                let upperBound = string.index(string.startIndex, offsetBy: 3+offSet)
                newText =  "\(string[lowerBound..<upperBound])-";
            }
            debugPrint(newText)
            if string.count > (5+offSet) {
                let lowerBound = string.index(string.startIndex, offsetBy: 3+offSet)
                let upperBound = string.index(string.startIndex, offsetBy: 6+offSet)
                newText = "\(newText)\(string[lowerBound..<upperBound])-";
            }
            debugPrint(newText)
            if string.count > (9+offSet) {
                let lowerBound = string.index(string.startIndex, offsetBy: 6+offSet)
                let upperBound = string.index(string.startIndex, offsetBy: 10+offSet)
                newText = "\(newText)\(string[lowerBound..<upperBound])";
            }
            print(newText)
            phoneNumberTextField.text = newText;
        }
        return false
    }
}


extension AddPhoneNumberPresenter: UpdateCustomerDelegate {
    
    func updateCustSuccess(id: String) {
        self.delegate?.success(msg: "Number added" , segue: "SendCodeSegue")
    }
    
    func updateCustFail(msg: String) {
        debugPrint(msg)
        let msg = NSLocalizedString("AddPhoneNumberGeneralError", comment: "")
        self.delegate?.failure(msg: msg)
    }
    
    
   
}

extension AddPhoneNumberPresenter: UITextFieldDelegate {
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
            self.delegate?.handleSendCode()
        }
        // Do not add a line break
        return false
    }
}



