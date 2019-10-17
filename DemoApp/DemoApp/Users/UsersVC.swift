//
//  UsersVC.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/17/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class UsersVC: UIViewController {
    
    @IBOutlet private weak var enrollButton: UIButton!
    @IBOutlet private weak var authStandardButton: UIButton!
    @IBOutlet private weak var authCustomButon: UIButton!
    @IBOutlet private weak var qrCodeImage: UIImageView!
    @IBOutlet private weak var updateButton: UIButton!
    
    private var swyftId = ""
    
    private let email = "fake.man@swyft.com"
    private let firstName = "Fake"
    private let lastName = "Man"
    private let phoneNumber = "+14152346543"
    
    @IBAction func onTapEnroll(_ sender: UIButton) {
        
        KVNProgress.show()
        
        let customerInfo = SwyftUser(
            email: email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber)
        
        SwyftSdk.enrollUser(user: customerInfo, success: { response in
            
            self.swyftId = response.swyftId
            
            print("message: \(response.message)")
            print("swyftId: \(response.swyftId)")
            print("authToken: \(response.authToken)")
            
            KVNProgress.showSuccess()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onTapAuthStandard(_ sender: UIButton) {
        
        KVNProgress.show()
        
        qrCodeImage.image = nil
        
        SwyftSdk.authenticateUser(swyftId: self.swyftId, qrCodeColor: self.view.tintColor, success: { response in
            
            DispatchQueue.main.async {
                self.qrCodeImage.image = response.qrCode
            }
            KVNProgress.showSuccess()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onTapAuthCustom(_ sender: UIButton) {
        
        KVNProgress.show()
        
        qrCodeImage.image = nil
        
        let customAuth = self.email
        
        SwyftSdk.authenticateUser(swyftId: self.swyftId, qrCodeColor: self.view.tintColor, customAuth: customAuth, success: { response in
            
            DispatchQueue.main.async {
                self.qrCodeImage.image = response.qrCode
            }
            KVNProgress.showSuccess()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onTapUpdateUser(_ sender: Any) {
        let screen: UpdateUserVC = loadViewController()
        screen.email = self.email
        screen.firstName = self.firstName
        screen.lastName = self.lastName
        screen.phoneNumber = self.phoneNumber
        
        navigationController?.pushViewController(screen, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enrollButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        authStandardButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        authCustomButon.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        updateButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
    }
}
