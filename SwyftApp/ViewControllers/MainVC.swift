//
//  MainVC.swift
//  customer
//
//  Created by Tom Manuel on 5/8/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: BaseVC {
    
    @IBOutlet weak var welcomeLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let customer = Session.currentSession.customer, let fName = customer.firstName {
            let loginCount = customer.logInCounter
            let welcome: String
            if loginCount < 2 {
                welcome = String.init(format: NSLocalizedString("Welcome1", comment: "Welcome Message"), fName)
            } else {
                welcome = String.init(format: NSLocalizedString("WelcomeN", comment: "Welcome Message"), fName)
            }
            welcomeLabel?.text = welcome
        }
        
        
    }
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        Session.signOut()
    }
    
    
    
}
