//
//  UpdateLogInCounter.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

internal class UpdateCustomer: FireStoreWrite {
    
    var success:SwyftConstants.writeSuccess
    
    var fail: SwyftConstants.fail
    
    var db: Firestore?
    
    required init(success: SwyftConstants.writeSuccess, fail: SwyftConstants.fail) {
        self.success = success;
        self.fail = fail;
        self.db = Configure.current.db
    }
        
    func querySuccess(msg: String, id: String) {
        if let _success = success {
            GetCustomer(success: {(data) in
                DispatchQueue.main.async {
                    _success(msg, id)
                }
            }, fail: {(err) in
                debugPrint(err)
            }).get(id: id)
            
        }
    }
    
    func queryFailure(msg: String) {
        if let _fail = fail {
            DispatchQueue.main.async {
                _fail(msg)
            }
        }
    }
    
    func put(key: String, data: Dictionary<String,Any>) {
        
        DispatchQueue.global(qos: .background).async {
            if let db = self.db {
                let ref = db.collection(SwyftConstants.CustomerCollection)
                let document = ref.document(key)
                
                self.updateDocument(document: document, data: data)
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.put(key: key, data:data)
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
    
    func add(key: String?, data: Dictionary<String,Any>) {
        
        DispatchQueue.global(qos: .background).async {
            if let db = self.db {
                if let key = key {
                    self.put(key: key, data: data)
                } else {
                    let ref = db.collection(SwyftConstants.CustomerCollection)
                    self.addDocument(collection: ref, data: data)
                }
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.add(key: key, data:data)
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
    
    func put(key: String, customer: Customer) {
        let data = customer.deserialize()
        put(key: key, data: data)        
    }
    
    func add(key: String?, customer: Customer) {
        let data = customer.deserialize()
        add(key: key, data: data)
    }
    
    
}
