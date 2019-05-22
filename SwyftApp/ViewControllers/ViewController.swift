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

import SwyftSDK

class SignInVC: UIViewController, GIDSignInUIDelegate, GetCustomerDelegate, CreateCustomerDelegate, UpdateCustomerDelegate {
    
    private var observers = [NSObjectProtocol]()
    private var db: Firestore?
    
    @IBOutlet weak var gSignInButton: GIDSignInButton!
    
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

  
    
    func updateCustSuccess() {
        if let db = db {
            let getCustomer = GetCustomer(db:db, delegate: self)
            let id = Session.currentSession.fbSession?.user.uid
            if let id = id {
                getCustomer.getCustomer(id: id)
            }
        }
    }
    
    func updateCustFail(msg: String) {
         print(msg)
    }    
    
    func updateCustSuccess(id: String) {
        print("customer updated: ", id)

    }
    
    func createCustSuccess(id: String) {
        print("customer created: ", id)
        let id = Session.currentSession.fbSession?.user.uid
        if let db = db, let id = id {
            let getCustomer = GetCustomer(db:db, delegate: self)
            getCustomer.getCustomer(id: id)
        }
    }
    
    func createCustFail(msg: String) {
        print(msg)
    }
    
    func getCustomerFail(msg: String) {
         print(msg)
         addCustomer()
    }
    
    func getCustomerSuccess(customer: Customer?) {
        if let customer = customer, customer.status == "active" {
            firstNameLabel.text = customer.firstName
            lastNameLabel.text = customer.lastName
            let session = Session.currentSession
            customer.signInMethod = session.signInMethod
            Session.currentSession.customer = customer
            updateCustomer(customer: customer)
        } else {
            let msg = "Error Signing In: customer is not active"
            print(msg)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        db = Firestore.firestore()
        addObservers()

    }
    
    @IBAction func signInBtn(_ sender: Any) {
        if let email = self.emailField.text, let password = self.passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] fbSession, error in
                guard let  _self = self, let db = _self.db else { return }
                
                if let error = error {
                    print(error)
                    return
                }
                
                let getCustomer = GetCustomer(db:db, delegate: _self)
                let session = Session.currentSession
                session.fbSession = fbSession
                session.signInMethod = "email/password"
                
                if let user = fbSession?.user, let email = user.email {
                    getCustomer.getCustomer(email: email)
                }
                
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)

    }
    
    
    private func addObservers() {
 
        let ob0 = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constants.FBSessionStart), object: nil,  queue: OperationQueue.main) {[weak self] (notification) -> Void in
            
            if let _self = self, let db = _self.db {
                let getCustomer = GetCustomer(db:db, delegate:_self)
                if let authResult = notification.userInfo?["authResult"] as? AuthDataResult {
                    let session = Session.currentSession
                    session.fbSession = authResult
                    session.signInMethod = "google"
                    if let email = authResult.user.email {
                        getCustomer.getCustomer(email: email)
                    } else {
                        getCustomer.getCustomer(id: authResult.user.uid)
                    }
                }
                
            }
        }
        
        observers.append(ob0)
    }
    
    func addCustomer() {
        let customer = Customer()
        let fbSession = Session.currentSession.fbSession
        if let fbSession = fbSession {
            let user = fbSession.user
            let userId = user.uid
            if let displayName = user.displayName {
                let names = Utils.getFirstAndLastName(fullName: displayName)
                customer.firstName = names[0]
                customer.lastName = names[1]
            }
            customer.emailAddress = user.email          
            customer.phoneNumber = user.phoneNumber
            customer.logInCounter = 1
            customer.status = "created"
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let dateString = formatter.string(from: Date())
            customer.createdOn = dateString
            customer.lastLogIn = dateString
            if let db = db {
                let createCustomer = CreateCustomer(db: db, delegate: self)
                createCustomer.createCustomer(id: userId, customer: customer)
            }
        }
       
        
    }
    
    func updateCustomer(customer: Customer) {
        customer.logInCounter = customer.logInCounter.advanced(by: 1)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let dateString = formatter.string(from: Date())
        customer.lastLogIn = dateString
        customer.signInMethod = Session.currentSession.signInMethod
        var id: String?
        if let _id = Session.currentSession.customer?.id {
          id = _id
        }  else if let _id = Session.currentSession.fbSession?.user.uid {
          id = _id
            if let customer = Session.currentSession.customer {
                customer.id = _id
            }
        }
        
        if let db = db, let id = id {
           let updateCustomer = UpdateCustomer(db: db, delegate: self)
           updateCustomer.updateCustomer(id: id, customer: customer)
        }
    }
    
    func updateCustomerWDict(customer: Customer) {
        var data : Dictionary<String, Any> = [:];
        
        data["logInCounter"] = customer.logInCounter.advanced(by: 1)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let dateString = formatter.string(from: Date())
        data["lastLogIn"]  = dateString
        
        let id = Session.currentSession.fbSession?.user.uid
        if let db = db, let id = id {
            let updateCustomer = UpdateCustomer(db: db, delegate: self)
            updateCustomer.updateCustomer(id: id, data: data)
        }
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "signUnSegue" {
            if let controller = segue.destination as? SignUpVC {
                 controller.emailField.text = controller.emailField.text
            }
        }
    }
    
    deinit{
        for ob in observers {
            NotificationCenter.default.removeObserver(ob)
        }
    }


}

