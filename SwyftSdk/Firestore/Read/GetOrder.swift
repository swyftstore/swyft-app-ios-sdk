//
//  GetOrder.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/3/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore


public class GetOrder: FireStoreRead{
    public var fail: SwyftConstants.fail
    public var success: SwyftConstants.readSuccess
    
    public var db: Firestore
    
    private var orders = Array<Order>()
    
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
        var ref: CollectionReference?
        
        ref = db.collection(SwyftConstants.OrderCollection)
        let doc = ref?.document(id)
        if let doc = doc {
            self.queryDB(document: doc)
        } else {
            self.queryFailure(msg: "Error loading collection")
        }
    }
    
}
