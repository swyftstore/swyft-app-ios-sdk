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

protocol UpdateDelegate {
    func updateMethods()
    func showProgress()
    func hideProgress()
}

class PaymentMethodsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet private weak var addPaymentButton: UIButton!
    @IBOutlet private weak var paymentMethodsTable: UITableView!
    
    private var paymentMethods = [SwyftPaymentMethod]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KVNProgress.show()
        getPaymentMethods()
    }
    
    @IBAction func onTapAddPayment(_ sender: UIButton) {
        
        let isDefault = false
        let cardNumber = "4111111111111111"
        let cardExpiry = "1021"        
        let cardType = "VISA"
        let cardHolderName = "Carl Peterson"
        let cvv = "987"
        
        let method = FullPaymentMethod(
            cardNumber: cardNumber,
            cardExpiry: cardExpiry,
            cardType: cardType,
            cardHolderName: cardHolderName,
            cvv: cvv)
        
        KVNProgress.show()
        
        SwyftSdk.addPaymentMethod(method: method, isDefault: isDefault, success: { response in
            self.getPaymentMethods()
            
        }) { error in
            print(error)
            KVNProgress.dismiss()
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
        let cell: CellPaymentMethod = tableView.dequeue(indexPath)
        let method = paymentMethods[indexPath.row]
        
        cell.title.text = method.last4
        cell.subtitle.text = method.cardType
        cell.method = method
        cell.delegate = self
        cell.addListeners()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: CellPaymentMethod = tableView.dequeue(indexPath)
     
       
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionDelete = UITableViewRowAction.init(
            style: UITableViewRowAction.Style.destructive,
            title: "Delete") { rowAction, indexPath in
                
                let method = self.paymentMethods[indexPath.row]
                
                SwyftSdk.deletePaymentMethod(deleteMethod: method, success: { response in
                    self.getPaymentMethods()
                }, failure: { error in
                    print(error)
                    KVNProgress.dismiss()
                })
        }
        
        return [actionDelete]
    }
    
    
    private func getPaymentMethods() {
        
        SwyftSdk.getPaymentMethods(success: { response in
            
            self.paymentMethods = response.paymentMethods
            self.paymentMethodsTable.reloadData()
            KVNProgress.showSuccess()
            
        }) { error in
            print(error)
            KVNProgress.dismiss()
        }
    }
}

extension PaymentMethodsVC: UpdateDelegate {
    func updateMethods() {
        getPaymentMethods()
    }
    
    func showProgress() {
         KVNProgress.show()
    }
    func hideProgress() {
         KVNProgress.dismiss()
    }
}

