//
//  GetStore.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/17/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore


internal class GetStore: FireStoreRead {
    var fail: SwyftConstants.fail
    var success: SwyftConstants.readSuccess
    
    var db: Firestore?
    
    required init(success: SwyftConstants.readSuccess, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let store = Store()
        store.serialize(data: data)
        store.id = id
        if done {
            DispatchQueue.main.async {
                self.success?(store)
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
            //var ref: CollectionReference?
            
            if let db = self.db {
                //
                //        ref = db.collection(SwyftConstants.StoreCollection)
                //        let doc = ref?.document(id)
                //        if let doc = doc {
                //            self.queryDB(document: doc)
                //        } else {
                //            self.queryFailure(msg: "Error loading collection")
                //        }
                let data = Utils.getMockData(fileName: "MockStores.json")
                if let data = data, let store = data[id] as? Dictionary<String, Any> {
                    self.querySuccess(data: store, id: id, done: false)
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

