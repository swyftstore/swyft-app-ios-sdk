//
//  GetOrder.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/3/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore


public class GetOrder: FireStoreRead {
    public var fail: SwyftConstants.fail
    public var success: SwyftConstants.readSuccess
    
    public var db: Firestore?
        
    public required init(success: SwyftConstants.readSuccess, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    public func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let order = Order()
        order.serialize(data: data)
        order.id = id
        if done {
            DispatchQueue.main.async {
                self.success?(order)
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
    
    public func get(id: String) {        
       
        DispatchQueue.global(qos: .background).async {
            var ref: CollectionReference?
            
            if let db = self.db {
                ref = db.collection(SwyftConstants.OrderCollection)
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
                    sleep(UInt32(SwyftConstants.WaitBetweenRetries))
                    n = n + 1
                }
            }
        }
    }
    
}
