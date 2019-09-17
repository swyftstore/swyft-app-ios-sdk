//
//  PaymentMethodsVC.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/17/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class PaymentMethodsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var addPaymentButton: UIButton!
    @IBOutlet private weak var paymentMethodsTable: UITableView!
    
    private let customerId = "qwerty12345"
    
    private var paymentMethods = [PaymentMethod]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KVNProgress.show()
        
        SwyftSdk.getPaymentMethods(customerId: customerId, success: { response in
            
            self.paymentMethods = response.paymentMethods
            self.paymentMethodsTable.reloadData()
            KVNProgress.dismiss()
            
        }) { error in
            KVNProgress.showError(withStatus: error.description)
        }
    }
    
    @IBAction func onTapAddPayment(_ sender: UIButton) {
        
        let isDefault = false
        let cardNumber = "4111111111111111"
        let cardExpiry = "10/2020"
        let cardType = "VISA"
        let cardHolderName = "Carl Peterson"
        let cvv = "987"
        
        let method = PaymentMethod(
            cardNumber: cardNumber,
            cardExpiry: cardExpiry,
            cardType: cardType,
            cardHolderName: cardHolderName,
            cvv: cvv)
        
        KVNProgress.show()
        
        SwyftSdk.addPaymentMethod(method: method, isDefault: isDefault, success: { response in
            
            SwyftSdk.getPaymentMethods(customerId: self.customerId, success: { response in
                
                self.paymentMethods = response.paymentMethods
                self.paymentMethodsTable.reloadData()
                KVNProgress.dismiss()
                
            }) { error in
                KVNProgress.showError(withStatus: error.description)
            }
            
        }) { error in
            KVNProgress.showError(withStatus: error.description)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        return cell
    }
}
