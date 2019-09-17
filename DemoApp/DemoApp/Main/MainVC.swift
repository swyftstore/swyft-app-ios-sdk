//
//  MainVC.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/10/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class MainVC: UIViewController {
    
    @IBOutlet private weak var usersButton: UIButton!
    @IBOutlet private weak var ordersButton: UIButton!
    @IBOutlet private weak var paymentMethodsButton: UIButton!
    
    @IBAction func onTapUsers(_ sender: UIButton) {
        let screen: UsersVC = loadViewController()
        navigationController?.pushViewController(screen, animated: true)
    }
    
    @IBAction func onTapOrders(_ sender: UIButton) {
        let screen: OrdersVC = loadViewController()
        navigationController?.pushViewController(screen, animated: true)
    }
    
    @IBAction func onTapPaymentMethods(_ sender: UIButton) {
        let screen: PaymentMethodsVC = loadViewController()
        navigationController?.pushViewController(screen, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        ordersButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
        paymentMethodsButton.layer.borderColor = #colorLiteral(red: 0.9803581834, green: 0.4278862476, blue: 0.1545831561, alpha: 1)
    }
}
