//
//  DefaultPaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class DefaultPaymentInteractor {
    
    public func removePaymentMethod(defaultMethod: SwyftPaymentMethod,
                                    success:SwyftConstants.defaultPaymentSuccess, failure: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session,
                let customer = session.customer {
                
                let _sucesss = success
                let _failure = failure
                var curentDefault: Int?
                var newDefault: Int?
                var index = 0
                for method in customer.paymentMethods {
                    if ( method.token == defaultMethod.token ) {
                        newDefault = index
                    } else if ( method.isDefault ) {
                        curentDefault = index
                    }
                    
                    if let _  = newDefault,
                        let _ = curentDefault {
                        break
                    }
                    index = index + 1
                }
                
                if let _  = newDefault  {
                    
                    customer.paymentMethods[curentDefault!].isDefault = false
                    if let _ = curentDefault {
                        customer.paymentMethods[newDefault!].isDefault = true
                    }
                    
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
