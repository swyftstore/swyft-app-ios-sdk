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
import SwyftSdk

protocol GetCustomerDelegate: class {
    func getCustomerSuccess(customer: Customer?)
    func getCustomerFail(msg: String)
}

class GetCustomer: NSObject{
    
    var getCustomer: SwyftSdk.GetCustomer?
    var customer: Customer?
    var delegate: GetCustomerDelegate?
    
    init(delegate: GetCustomerDelegate) {
        super.init()       
        self.delegate = delegate;
    }
    
    func getCustomer(id: String) {
        
        self.getCustomer = SwyftSdk.GetCustomer(success: {(customer)->Void in
            //handle success
            if let _customer = customer as? Customer {
                self.customer = _customer;
                self.delegate?.getCustomerSuccess(customer: self.customer)
            }
        }, fail: {(msg)->Void in
            //handle failure
            self.delegate?.getCustomerFail(msg: msg)
        })
        
        self.getCustomer?.get(id: id)
    }
    
    func getCustomer(email: String) {
        self.getCustomer = SwyftSdk.GetCustomer(success: {(customer)->Void in
            //handle success
            if let _customer = customer as? Customer {
                self.customer = _customer;
                self.delegate?.getCustomerSuccess(customer: self.customer)
            }
        }, fail: {(msg)->Void in
            //handle failure
            self.delegate?.getCustomerFail(msg: msg)
        })
        self.getCustomer?.get(email: email)
    }
    
    
}
