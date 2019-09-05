//
//  GetOrders.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class GetOrders: FireStoreRead{
    public var fail: SwyftConstants.fail
    public var success: SwyftConstants.readSuccessWArray
    
    public var db: Firestore?
    
    private var orders = Array<Order>()
    
    public required init(success: SwyftConstants.readSuccessWArray, fail: SwyftConstants.fail) {
        self.success = success
        self.fail = fail
        self.db = Configure.current.db!
    }
    
    public func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool) {
        let order = Order()
        order.serialize(data: data)
        order.id = id
        orders.append(order)
        if done {
            DispatchQueue.main.async {
                self.success?(self.orders)
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
    
    public func get(customerId: String, startIndex: Int, limit: Int) {
        orders.removeAll()
        
        DispatchQueue.global(qos: .background).async {            
            if let db = self.db {
                let query = db.collection(SwyftConstants.OrderCollection).whereField(SwyftConstants.CustomerId, isEqualTo: customerId).order(by: SwyftConstants.OrderCreationDate).start(at: [startIndex]).limit(to: limit)
                self.queryDB(query: query)
            } else {
                var n = 0
                while (true) {
                    self.db = Configure.current.db
                    if let _ = self.db {
                        self.get(customerId: customerId, startIndex: startIndex, limit:limit)
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
