//
//  UpdateLogInCounter.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class UpdateCustomer: FireStoreWrite {
    
    public var success:SwyftConstants.writeSuccess
    
    public var fail: SwyftConstants.fail
    
    public var db: Firestore?
    
    public required init(success: SwyftConstants.writeSuccess, fail: SwyftConstants.fail) {
        self.success = success;
        self.fail = fail;
        self.db = Configure.current.db
    }
        
    public func querySuccess(msg: String, id: String) {
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
    
    public func queryFailure(msg: String) {
        if let _fail = fail {
            DispatchQueue.main.async {
                _fail(msg)
            }
        }
    }
    
    public func put(key: String, data: Dictionary<String,Any>) {
        
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
    
    public func add(key: String?, data: Dictionary<String,Any>) {
        
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
    
    public func put(key: String, customer: Customer) {
        let data = customer.deserialize()
        put(key: key, data: data)        
    }
    
    public func add(key: String?, customer: Customer) {
        let data = customer.deserialize()
        add(key: key, data: data)
    }
    
    
}
