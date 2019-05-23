//
//  FireStoreRead.swift
//  Dropspot
//
//  Created by Tom Manuel on 5/1/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public protocol FireStoreRead: class {
    typealias successClbk = ((_ data: FireStoreModelProto)->Void)?
    typealias failClbk = ((_ msg: String)->Void)?
    
    var success: FireStoreRead.successClbk {get}
    var fail: FireStoreRead.failClbk {get}
    var db: Firestore {get}
    
    init(success: successClbk, fail: failClbk)

    func querySuccess(data: Dictionary<String, Any>, id: String)
    func queryFailure(msg: String)
    func get(id: String)
    
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
                        for document in documents as [AnyObject] {
                            if let data = document.data() {
                                debugPrint(data)
                                self.querySuccess(data:data, id: document.documentID)
                            } else {
                                 self.queryFailure(msg: "document not found")
                            }                            
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
                        self.querySuccess(data: data, id: snap.documentID)
                    } else {
                        self.queryFailure(msg: "document not found")
                    }
                }
            })
        }
    }
    
    
    
}
