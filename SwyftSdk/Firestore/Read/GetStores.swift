//
//  GetStores.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class GetStores: FireStoreRead{
    public var fail: SwyftConstants.fail
    public var success: SwyftConstants.readSuccessWArray
    
    public var db: Firestore
    
    private var stores = Array<Store>()
    
    public required init(success: SwyftConstants.readSuccessWArray, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    public func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let store = Store()
        store.serialize(data: data)
        store.id = id
        stores.append(store)
        if done {
            DispatchQueue.main.async {
                self.success?(self.stores)
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
    
    public func get(key: SwyftConstants.StoreSearchKey, value: Any) throws {
        var ref: CollectionReference?
        var query: Query?
        
        ref? = db.collection(SwyftConstants.StoreCollection)
        
        if key == SwyftConstants.StoreSearchKey.GeoPoint,
            let _value = value as? GeoPoint {
            let data = Utils.getMockData(fileName: "MockStores.json")
            if let data = data {
                let index = 0;
                for (key, store) in data {
                    if let _store = store as? Dictionary<String, Any> {
                        if (index < data.count) {
                            querySuccess(data: _store, id: key, done: false)
                        } else {
                            querySuccess(data: _store, id: key, done: true)

                        }
                    }
                }
            }
        } else if let _value = value as? String {
            let _key = key.rawValue
            query = ref?.whereField(_key, isEqualTo: _value)
        } else {
            throw SwyftConstants.ClientError.runtimeError("Invalid key or value type")
        }
        
        if let query = query {
            self.queryDB(query: query)
        } else {
            self.queryFailure(msg: "Error loading collection")
        }
    }
    
    
    
}
