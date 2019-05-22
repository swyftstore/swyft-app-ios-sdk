//
//  getCustomerPoc.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/2/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwyftSDK

protocol GetCustomerDelegate: class {
    func getCustomerSuccess(customer: Customer?)
}

class GetCustomer: NSObject{
    
    var getCustomer: GetCustomer?
    var customer: Customer?
    var db: Firestore?
    var delegate: GetCustomerDelegate?
    
    init(db: Firestore, delegate: GetCustomerDelegate) {
        super.init()
        self.db = db
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        self.delegate = delegate;
    }
    
    func getCustomer(id: String) {
        if let _db = self.db {
            self.getCustomer = GetCustomer(db: _db, success: {(customer)->Void in
                //handle success
                if let _customer = customer as? Customer {
                    self.customer = _customer;
                    self.delegate?.getCustomerSuccess(customer: self.customer)
                }
            }, fail: {(msg)->Void in
                //handle failure
                print(msg)
            })
            self.getCustomer?.get(key: id)
        }
    }
    
    
}
