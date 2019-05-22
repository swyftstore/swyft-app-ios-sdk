//
//  ViewController.swift
//  customer
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import JVFloatLabeledTextField

import SwyftSdk


class SignInVC: BaseVC, SignInProtocol, GIDSignInUIDelegate {
    var presenter: SignInPresenter?
    
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
    
    private var observers = [NSObjectProtocol]()
    
    var email: String?
    
    @IBOutlet weak var gSignInButton: GIDSignInButton!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
 
    @IBAction func signInClick(_ sender: Any) {
        self.view.endEditing(true)
        if let email = self.emailField.text, let password = self.passwordField.text {
            self.presenter?.signInHandler(email: email, password: password)
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = SignInPresenter(delegate: self)
        addObservers()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let email = self.email {
            self.emailField.text = email;
        }
        
        if Auth.auth().currentUser != nil,
            let user = Auth.auth().currentUser {
            self.presenter?.loadCustomerHandler(user: user)
        }
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        passwordField.addBottomBoarder(color: Constants.floatPlaceholderColor)
        emailField.addBottomBoarder(color: Constants.floatPlaceholderColor)
    }
    
    private func setupViews() {
        passwordField.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        passwordField.tag = 2
        passwordField.delegate = self;
        passwordField.floatingLabelActiveTextColor = Constants.floatPlaceholderColor
        
        
        emailField.placeholder = NSLocalizedString("EmailPlaceholder", comment: "")
        emailField.tag = 1
        emailField.delegate = self;
        emailField.floatingLabelActiveTextColor =  Constants.floatPlaceholderColor
        
     
        emailSignInButton.titleLabel?.text = NSLocalizedString("SignIn", comment: "")
        emailSignInButton.tag = 3
        
        forgotPasswordButton.titleLabel?.text = NSLocalizedString("ForgotPassword", comment: "")
        signUpButton.titleLabel?.text = NSLocalizedString("SignUp", comment: "")
        dontHaveAccountLabel.text = NSLocalizedString("DontHaveAccount", comment: "")
    }
    

    
    
    private func addObservers() {
 
        let ob0 = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constants.FBSessionStart), object: nil,  queue: OperationQueue.main) {[weak self] (notification) -> Void in
            
            if let _self = self {
                
                if let authResult = notification.userInfo?["authResult"] as? AuthDataResult {
                    let session = Session.currentSession
                    session.fbSession = authResult
                    _self.presenter?.loadCustomerHandler(user: authResult.user, signInMethod: Constants.Google)
                    
                }
                
            }
        }
        
        observers.append(ob0)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "SignUpSegue" {
            if let controller = segue.destination as? SignUpVC {
               controller.email = self.emailField.text
            }
        } 
    }
    
    deinit{
        for ob in observers {
            NotificationCenter.default.removeObserver(ob)
        }
    }
}

extension SignInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            if let email = self.emailField.text, let password = self.passwordField.text {
                self.presenter?.signInHandler(email: email, password: password)
            }
        }
        // Do not add a line break
        return false
    }
}
