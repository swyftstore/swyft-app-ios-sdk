//
//  GetCustomers.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import FirebaseFirestore


class GetCustomer: FireStoreRead {

    var success: SwyftConstants.readSuccess
    var fail:  SwyftConstants.fail
    var db: Firestore?
    
    required init(success:  SwyftConstants.readSuccess, fail:  SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db
    }
    
    func get(id: String) {
        
        DispatchQueue.global(qos: .background).async {
            var ref: CollectionReference?
            
            if let db = self.db {
                ref = db.collection(SwyftConstants.CustomerCollection)
                let doc = ref?.document(id)
                if let doc = doc {
                    self.queryDB(document: doc)
                } else {
                    self.queryFailure(msg: "Error loading collection")
                }
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.get(id: id)
                        break;
                    } else if n > SwyftConstants.MaxDbRetries {
                        self.queryFailure(msg: "DB instance unable to initialize")
                        break;
                    }
                    
                    usleep(UInt32(SwyftConstants.WaitBetweenRetries))
                    n = n + 1
                }
            }
        }
    }
    
    func get(email: String) {
        DispatchQueue.global(qos: .background).async {
            var ref: CollectionReference?
            
            if let db = self.db {
                ref = db.collection(SwyftConstants.CustomerCollection)
                let query = ref?.whereField(SwyftConstants.EmailAddress, isEqualTo: email)
                if let query = query {
                    self.queryDB(query: query)
                } else {
                    self.queryFailure(msg: "Error loading collection")
                }
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.get(email: email)
                        break;
                    } else if n > SwyftConstants.MaxDbRetries {
                        self.queryFailure(msg: "DB instance unable to initialize")
                        break;
                    }
                    usleep(UInt32(SwyftConstants.WaitBetweenRetries))
                    n = n + 1
                }
            }
        }
    }
    
    func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let customer = Customer()
        customer.serialize(data: data)
        customer.id = id
        Configure.current.session?.customer = customer
        if done {
            DispatchQueue.main.async {
                self.success?(customer)
            }
        }
    }
    
    func queryFailure(msg: String) {
        if let _fail = fail {
            DispatchQueue.main.async {
                _fail(msg)
            }
        }
    }
}
