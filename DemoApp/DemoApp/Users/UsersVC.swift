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
    
    private var swyftId = ""
    
    @IBAction func onTapEnroll(_ sender: UIButton) {
        
        KVNProgress.show()
        
        let customerInfo = SwyftUser(
            email: "test15@rigo.com",
            firstName: "Carl",
            lastName: "Perterson",
            phoneNumber: "+1 1234567890")
        
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
        
        let customAuth = "myCustomStringToEncode"
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enrollButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        authStandardButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        authCustomButon.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
    }
}
