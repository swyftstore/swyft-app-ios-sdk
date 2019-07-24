//
//  FireStoreRead.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

public protocol FireStoreRead: class {
   
    var fail: SwyftConstants.fail {get}
    var db: Firestore {get}
    
    func querySuccess(data: Dictionary<String, Any>, id: String, done: Bool)
    func queryFailure(msg: String)
}

extension FireStoreRead {
    
    func queryDB(query: Query)  {
        DispatchQueue.global(qos: .background).async {
            query.getDocuments() { (querySnapshot, err) in
                if let _err = err {
                    self.queryFailure(msg: _err.localizedDescription)
                } else {
                    if let snap = querySnapshot, !snap.isEmpty {                        
                        let documents = snap.documents
                        let size = documents.count
                        var done = false
                        var index = 1
                        for document in documents as [AnyObject] {
                           
                            if let data = document.data() {
                                debugPrint(data)
                                if index >= size {
                                    done = true
                                }
                                self.querySuccess(data:data, id: document.documentID, done: done)
                            } else {
                                print("Warning: document does not contain data")
                            }
                            index += 1
                        }
                    } else {
                        self.queryFailure(msg: "document not found")
                    }
                    
                }
            }
        }
    }
    
    func queryDB(document: DocumentReference)  {
       DispatchQueue.global(qos: .background).async {
            document.getDocument(completion: { (documentSnapshot, err) in
                if let err = err {
                    debugPrint("Error loading document \(err)")
                    self.queryFailure(msg: err.localizedDescription)
                } else {
                    if let snap = documentSnapshot, snap.exists, let data = snap.data() {            
                        self.querySuccess(data: data, id: snap.documentID, done: true)
                    } else {
                        self.queryFailure(msg: "document not found")
                    }
                }
            })
        }
    }
    
    
    
}
