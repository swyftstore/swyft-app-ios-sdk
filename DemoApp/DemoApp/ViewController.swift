//
//  ViewController.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/10/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class ViewController: UIViewController {
    
    @IBOutlet private weak var buttonInit: UIButton!
    @IBOutlet private weak var buttonEnroll: UIButton!
    @IBOutlet private weak var buttonCustomerAuthA: UIButton!
    @IBOutlet private weak var buttonCustomerAuthB: UIButton!
    @IBOutlet private weak var qrCodeImage: UIImageView!
    
    private var swyftId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonInit.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        buttonEnroll.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        buttonCustomerAuthA.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        buttonCustomerAuthB.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
    }
    
    
    @IBAction func onTapInit(_ sender: UIButton) {
        SwyftSdk.Configure.qrColor = self.view.tintColor
    }
    
    @IBAction func onTapEnroll(_ sender: UIButton) {
        
        KVNProgress.show()
        
        let customerInfo = SwyftUser(
            email: "test15@rigo.com",
            firstName: "Carl",
            lastName: "Perterson",
            phoneNumber: "+1 1234567890")
        
        SwyftSdk.Configure.enrollUser(swyftUser: customerInfo, success: { response in
            
            self.swyftId = response.swyftId
            
            print("message: \(response.message)")
            print("swyftId: \(response.swyftId)")
            print("authToken: \(response.authToken)")
            
            KVNProgress.dismiss()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onTapCustomerAuthA(_ sender: UIButton) {
        
        KVNProgress.show()
        
        qrCodeImage.image = nil
        
        SwyftSdk.Configure.authenticateUser(swyftId: self.swyftId, success: { response in
                        
            DispatchQueue.main.async {
                self.qrCodeImage.image = response.qrCode
            }
            KVNProgress.dismiss()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onTapCustomerAuthB(_ sender: UIButton) {
        
        KVNProgress.show()
        
        qrCodeImage.image = nil
        
        let customAuth = "myCustomStringToEncode"
        
        SwyftSdk.Configure.authenticateUser(swyftId: self.swyftId, customAuth: customAuth, success: { response in
            
            DispatchQueue.main.async {
                self.qrCodeImage.image = response.qrCode
            }
            KVNProgress.dismiss()
            
        }) { error in
            debugPrint(error)
            KVNProgress.dismiss()
        }
    }
    
}
