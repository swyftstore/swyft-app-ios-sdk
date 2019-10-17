//
//  UpdateUserVC.swift
//  DemoApp
//
//  Created by Tom Manuel on 10/15/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class UpdateUserVC: UIViewController {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var updateUserButton: UIButton!
    
    
    @IBAction func onSubmitTap(_ sender: Any) {
        KVNProgress.show()
        
        var swyftUser: SwyftUser
        var _email: String
        var _firstname: String?
        var _lastname: String?
        var _phoneNumber: String?
        
        if let firstName = self.firstNameField.text {
            _firstname = firstName
        } else {
            _firstname = self.firstName
        }
        
        if let lastName = self.lastNameField.text {
            _lastname = lastName
        } else {
            _lastname = self.lastName
        }
        
        if let email = self.emailField.text {
            _email = email
        } else {
            _email = self.email!
        }
        
        if let phoneNumber = self.phoneNumberField.text {
            _phoneNumber = phoneNumber
        } else {
            _phoneNumber = self.phoneNumber
        }
        
        swyftUser = SwyftUser(email: _email, firstName: _firstname, lastName: _lastname, phoneNumber: _phoneNumber)
       
        SwyftSdk.updateUser(user: swyftUser, success: { (SwyftUpdateUserResponse) in  
            print(SwyftUpdateUserResponse.message)
            KVNProgress.showSuccess()
        }) { (error) in
            print(error)
            KVNProgress.dismiss()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.text = firstName
        lastNameField.text = lastName
        emailField.text = email
        phoneNumberField.text = phoneNumber
        updateUserButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        
    }
    
}
