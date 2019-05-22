//
//  AddPhoneNumberVC.swift
//  customer
//
//  Created by Tom Manuel on 5/8/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import JVFloatLabeledTextField

import SwyftSdk

class AddPhoneNumberVC: BaseVC, AddPhoneNumberProtocol {
    var presenter: AddPhoneNumberPresenter?
    
    func success(msg: String, segue: String?) {
        debugPrint(msg)
        self.hideLoadingHud()
        if let _segue = segue {
            performSegue(withIdentifier: _segue, sender: nil)
        }
    }
    
    func failure(msg: String) {
        debugPrint(msg)
        self.hideLoadingHud()
        showError(errorMsg: msg, completion: nil)
    }
    
    func validation() -> Bool {
        //todo: handle validation
        return true
    }
    
    func handleSendCode() {
        let countryCode: String
        self.view.endEditing(true)
        if let _countryCode = self.countryCodeInput?.text, _countryCode.count > 0 {
            countryCode = _countryCode
        } else {
            countryCode = NSLocalizedString("AddPhoneNumberDefaultCountryCode", comment: "")
        }
        
        if let phoneNumber = self.phoneNumberInput?.text {
            self.presenter?.addNumberHandler(countryCode: countryCode, phoneNumber: phoneNumber)
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var phoneNumberInput: UITextField?
    @IBOutlet weak var sendCodeBtn: UIButton?
    @IBOutlet weak var countryCodeInput: UITextField?
    
    @IBAction func backButton(_ sender: Any) {
        self.view.endEditing(true)
        Session.signOut()
    }
    
    
    @IBAction func sendCodeClick(_ sender: Any) {
        handleSendCode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = AddPhoneNumberPresenter(delegate: self)
        if let view = self.phoneNumberInput as? JVFloatLabeledTextField {
            view.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        }
        setupViews()
        
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews();
         self.phoneNumberInput?.addBottomBoarder(color: Constants.floatPlaceholderColor)
         self.countryCodeInput?.addBottomBoarder(color: Constants.floatPlaceholderColor)
    }
    
    func setupViews() {
        let title = NSLocalizedString("AddPhoneNumberTitle", comment: "")
        let desc = NSLocalizedString("AddPhoneNumberDesc", comment: "")
        let sendCode = NSLocalizedString("AddPhoneNumberSendCodeBtn", comment: "")
        let phoneNumberPlaceHolder = NSLocalizedString("AddPhoneNumberPhoneNumberInputPlaceholder", comment: "")
        self.titleLabel?.text = title;
        self.descLabel?.text = desc
        self.phoneNumberInput?.placeholder = phoneNumberPlaceHolder
        self.sendCodeBtn?.setTitle(sendCode, for: .normal)
    }

}

extension AddPhoneNumberVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            handleSendCode()
        }
        // Do not add a line break
        return false
    }
}
