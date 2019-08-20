//
//  GetStore.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/17/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore


public class GetStore: FireStoreRead {
    public var fail: SwyftConstants.fail
    public var success: SwyftConstants.readSuccess
    
    public var db: Firestore
    
    public required init(success: SwyftConstants.readSuccess, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    public func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let store = Store()
        store.serialize(data: data)
        store.id = id
        if done {
            DispatchQueue.main.async {
                self.success?(store)
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
//        var ref: CollectionReference?
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
            querySuccess(data: store, id: id, done: false)
        }

    }
    
}

