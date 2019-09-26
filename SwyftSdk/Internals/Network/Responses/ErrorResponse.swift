//
//  ErrorResponse.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/25/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import XMLMapper

internal class ErrorResponse: XmlResponseBase {
    private let errorStringKey = "ERRORSTRING"
    
    var errorString: String?
    
    required init?(map: XMLMap) {
        super.init()
        errorString = map[errorStringKey].currentValue as? String        
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
