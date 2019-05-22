//
//  UpdateCustomer.swift
//  customer
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//


import Foundation
import Firebase
import FirebaseFirestore
import SwyftSdk

protocol UpdateCustomerDelegate: class {
    func updateCustSuccess(id: String)
    func updateCustFail(msg: String)
}

class UpdateCustomer: NSObject {
    var updateCustomer: SwyftSdk.UpdateCustomer?
    var customer: Customer?
    var delegate: UpdateCustomerDelegate?
    
    init(delegate: UpdateCustomerDelegate) {
        super.init()
        self.delegate = delegate;
        
        self.updateCustomer = SwyftSdk.UpdateCustomer(success: { (msg, id) in
            if let id = id {
                self.delegate?.updateCustSuccess(id: id)
            }
        }, fail: { (msg) in
            self.delegate?.updateCustFail(msg: msg)
        })
    }
    
    func updateCustomer(id:String, customer: Customer){
        let data = customer.deserialize()
        updateCustomer?.put(key: id, data: data)
    }
    
    func updateCustomer(id:String, data: Dictionary<String, Any>){
        updateCustomer?.put(key: id, data: data)
    }
}

