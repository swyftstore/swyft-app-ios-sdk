//
//  FireStoreWrite.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public protocol FireStoreWrite: class {
    typealias successClbk = ((_ msg: String, _ id: String?)->Void)?
    typealias failClbk = ((_ msg: String)->Void)?
    
    var success: successClbk {get}
    var fail: failClbk {get}
    var db: Firestore {get}
    
    init(success: successClbk, fail: failClbk)
    
    func querySuccess(msg: String, id: String)
    func queryFailure(msg: String)
    func put(key: String, data: Dictionary<String,Any>)
}

extension FireStoreWrite {
    
    func addDocument(document: DocumentReference, data: Dictionary<String,Any>)  {
        DispatchQueue.global(qos: .background).async {
            document.setData(data) { err in
                if let err = err {
                    self.queryFailure(msg: "\(err)")
                } else {
                   self.querySuccess(msg: "Document Created", id: document.documentID)
                }
            }
        }
    }
    
    func addDocument(collection: CollectionReference, data: Dictionary<String,Any>)  {
        DispatchQueue.global(qos: .background).async {
            var ref: DocumentReference? = nil
            ref = collection.addDocument(data: data) { err in
                if let err = err {
                    self.queryFailure(msg: "\(err)")
                } else {
                    self.querySuccess(msg: "Document Created", id: ref!.documentID)
                }
            }
        }
    }
    
    func updateDocument(document: DocumentReference, data: Dictionary<String,Any>) {
        DispatchQueue.global(qos: .background).async {
            document.setData(data, merge: true) { err in
                if let err = err {
                    self.queryFailure(msg: "\(err)")
                } else {
                    self.querySuccess(msg: "Document Updated", id: document.documentID)
                }
            }
        }
    }
    
    
}
