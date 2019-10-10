//
//  GetPaymentMethods.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

internal class GetPaymentMethods: FireStoreRead {
    
    var success: SwyftConstants.readSuccessWArray
    var fail:  SwyftConstants.fail
    var db: Firestore?
    
    required init(success: SwyftConstants.readSuccessWArray, fail: SwyftConstants.fail) {
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
                    } else if n > SwyftConstants.MaxDBRetries {
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
        let methods = customer.paymentMethods.map({$0.value})
        
        if done {
            DispatchQueue.main.async {
                self.success?(methods)
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
