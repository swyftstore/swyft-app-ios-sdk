//
//  GetProducts.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

internal class GetProduct: FireStoreRead {
    var fail: SwyftConstants.fail
    var success: SwyftConstants.readSuccess
    
    var db: Firestore?
    
    private var orders = Array<Order>()
    
    required init(success: SwyftConstants.readSuccess, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let order = Order()
        order.serialize(data: data)
        order.id = id
        if done {
            DispatchQueue.main.async {
                self.success?(order)
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
    
    func get(id: String) {        
        
        DispatchQueue.global(qos: .background).async {
            var ref: CollectionReference?
            
            if let db = self.db {
                ref = db.collection(SwyftConstants.ProductCollection)
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
    
}
