//
//  SignUpVC.swift
//  customer
//
//  Created by Tom Manuel on 5/8/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import SwyftSdk
import Firebase
import FirebaseAuth
import JVFloatLabeledTextField


class SignUpVC: BaseVC, SignUpProtocol {
   
    
    var presenter: SignUpPresenter?
    
    func success(msg: String, segue: String?) {
        debugPrint(msg)
        self.hideLoadingHud()
        if let _segue = segue {
            performSegue(withIdentifier: _segue, sender: nil)
        }
    }
    
    func failure(msg: String) {
        print(msg)
        self.hideLoadingHud()
        self.showError(errorMsg: msg, completion: nil)
    }
    
    func validation() -> Bool {
        //todo: handle validation
        return true
    }
    
    var email: String?
    
    
    @IBOutlet weak var firstNameField: JVFloatLabeledTextField?
    
    @IBOutlet weak var lastNameField: JVFloatLabeledTextField?
    
    @IBOutlet weak var emailField: JVFloatLabeledTextField?
    
    @IBOutlet weak var passwordField: JVFloatLabeledTextField?
    
    @IBOutlet weak var signUpButton: UIButton?
    
    @IBOutlet var alreadyHaveAccountLabel: UILabel?
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.handleSignUp()
    }
    
    @IBAction func logInClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = self.email {
            self.emailField?.text = email;
        }
        self.presenter = SignUpPresenter(delegate: self)
        setupViews()
    }
    
    private func handleSignUp() {
        let email = self.emailField!.text!
        let password = self.passwordField!.text!
        let firstName = self.firstNameField!.text!
        let lastName = self.lastNameField!.text!
        self.presenter?.signUpHandler(email:email, password:password, firstName:firstName, lastName:lastName)
        
    }
    
    private func setupViews() {
        emailField?.placeholder = NSLocalizedString("EmailPlaceholder", comment: "")
        emailField?.tag = 3
        emailField?.delegate = self
        emailField?.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        
        passwordField?.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        passwordField?.tag = 4
        passwordField?.delegate = self
        passwordField?.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        
        firstNameField?.placeholder = NSLocalizedString("FirstNamePlaceHolder", comment: "")
        firstNameField?.tag = 1
        firstNameField?.delegate = self
        firstNameField?.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        
        lastNameField?.placeholder = NSLocalizedString("LastNamePlaceHolder", comment: "")
        lastNameField?.tag = 2
        lastNameField?.delegate = self
        lastNameField?.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        
        
        alreadyHaveAccountLabel?.text = NSLocalizedString("AlreadyHaveAnAccount", comment: "")
        signUpButton?.titleLabel?.text = NSLocalizedString("SignUp", comment: "")
        signInButton?.titleLabel?.text = NSLocalizedString("SignIn", comment: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        emailField?.addBottomBoarder(color: Constants.floatPlaceholderColor)
        passwordField?.addBottomBoarder(color: Constants.floatPlaceholderColor)
        firstNameField?.addBottomBoarder(color: Constants.floatPlaceholderColor)
        lastNameField?.addBottomBoarder(color: Constants.floatPlaceholderColor)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if  segue.identifier == "signInSegue" {
//            if let controller = segue.destination as? SignInVC {              
//                controller.email = self.emailField?.text
//            }
//        }
    }

}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            handleSignUp()
        }
        // Do not add a line break
        return false
    }
}
