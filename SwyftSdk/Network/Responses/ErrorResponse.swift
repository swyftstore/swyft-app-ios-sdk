//
//  ErrorResponse.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/25/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

class ErrorResponse: XMLModel {
    private let errorStringKey = "ERRORSTRING"
    
    var errorString: String
    
    required public init?(map: XMLMap) {
        errorString = map[errorStringKey].currentValue as! String
        super.init()
    }
    
}

extension ErrorResponse: XMLMappable {
    var nodeName: String! {
        get {
            return "ERROR"
        }
        set(newValue) {
            
        }
    }
    
    func mapping(map: XMLMap) {
        errorString <- map[errorStringKey]
    }
}
