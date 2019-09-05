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
    
    public var db: Firestore?
    
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
    
    public func get(key: SwyftConstants.StoreSearchKey, value: Any)  {
      
        
        DispatchQueue.global(qos: .background).async {
            var ref: CollectionReference?
            
            if let db = self.db {
                var ref: CollectionReference?
                var query: Query?
                
                ref? = db.collection(SwyftConstants.StoreCollection)
                
                if key == SwyftConstants.StoreSearchKey.GeoPoint,
                    let _value = value as? [Double] {
                    let data = Utils.getMockData(fileName: "MockStores")
                    if let data = data {
                        var index = 1;
                        for (key, store) in data {
                            
                            
                            if let _store = store as? Dictionary<String, Any> {
                                if (index < data.count) {
                                    self.querySuccess(data: _store, id: key, done: false)
                                } else {
                                    self.querySuccess(data: _store, id: key, done: true)
                                }
                                index = index+1
                            }
                        }
                    }
                } else if let _value = value as? String {
                    let _key = key.rawValue
                    query = ref?.whereField(_key, isEqualTo: _value)
                } else {
                    self.queryFailure(msg: "Invalid key or value type")
                }
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.get(key: key, value: value)
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
    
    
    
}
