//
//  GetCustomers.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import FirebaseFirestore


public class GetCustomer: FireStoreRead {
       
    public var success: FireStoreRead.successClbk
    public var fail: FireStoreRead.failClbk
    public var db: Firestore
    
    public required init(success: FireStoreRead.successClbk, fail: FireStoreRead.failClbk) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    public func get(id: String) {
        var ref: CollectionReference?
        
        ref = db.collection(SwyftConstants.CustomerCollection)
        let doc = ref?.document(id)
        if let doc = doc {
            self.queryDB(document: doc)
        } else {
            self.queryFailure(msg: "Error loading collection")
        }
    }
    
    public func get(email: String) {
        var ref: CollectionReference?
        
        ref = db.collection(SwyftConstants.CustomerCollection)
        let query = ref?.whereField(SwyftConstants.EmailAddress, isEqualTo: email)
        if let query = query {
            self.queryDB(query: query)
        } else {
            self.queryFailure(msg: "Error loading collection")
        }
    }
    
    public func querySuccess(data: Dictionary<String, Any>, id: String) {
        let customer = Customer()
        customer.serialize(data: data)
        customer.id = id
        Configure.current.session?.customer = customer
        if let _success = success {
            DispatchQueue.main.async {
                _success(customer)
            }
        }
    }
    
    public func queryFailure(msg: String) {
        if let _fail = fail {
            DispatchQueue.main.async {
                _fail(msg)
            }
        }
    }
}
