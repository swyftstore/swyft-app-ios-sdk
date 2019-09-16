//
//  DefaultPaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


internal class DefaultPaymentInteractor {
    
    static func setDefaultPaymentMethod(defaultMethod: SwyftPaymentMethod,
                                    success:SwyftConstants.defaultPaymentSuccess, failure: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session,
                let customer = session.customer {
                
                let _sucesss = success
                let _failure = failure
                var newDefault: SwyftPaymentMethod?
                
                if let token = defaultMethod.token {
                    newDefault = customer.paymentMethods[token]
                }
                
                if let _  = newDefault  {
                    
                    customer.defaultPaymentMethod = defaultMethod.token
                    
                    let update = UpdateCustomer.init(success: { (msg, id) in
                        DispatchQueue.main.async {
                            _sucesss?()
                        }
                    }, fail: {failure in
                        DispatchQueue.main.async {
                            _failure?("Unable to update customer profile")
                        }
                    })
                    update.put(key: customer.id!, customer: customer)
                } else {
                    DispatchQueue.main.async {
                        let msg = "Payment Method Not registered."
                        print("Remove Payment Method Error: \(msg)")
                        failure?(msg)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let msg = "Session Ended. Cannot set default payment method"
                    print("Remove Payment Method Error: \(msg)")
                    failure?(msg)
                }
            }
        }
        
    }
}
