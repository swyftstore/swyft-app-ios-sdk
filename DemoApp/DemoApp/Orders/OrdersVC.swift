//
//  OrdersVC.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/17/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk
import KVNProgress

class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var ordersTable: UITableView!
    
    private var orders = [Order]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KVNProgress.show()
        
        let start = 1
        let pageSize = 20
        
        SwyftSdk.getOrders(start: start, pageSize: pageSize, success: { response in
            
            self.orders = response.orders
            self.ordersTable.reloadData()
            KVNProgress.dismiss()
            
        }) { error in
            KVNProgress.showError(withStatus: error.description)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        return cell
    }
}
