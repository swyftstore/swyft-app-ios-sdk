//
//  EditPaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/5/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

public class EditPaymentInteractor {
    
    public func editPaymentMethod(method: EditPaymentMethod, isDefault: Bool,
                                 success:SwyftConstants.editPaymentSuccess, failure: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session, let customer = session.customer {
                let last4 = method.last4
                let cardType = method.cardType
                let _sucesss = success
                let _failure = failure
                var cardFound = false
                
                for method in customer.paymentMethods.values {
                    if ( last4 ==  method.last4 && cardType == method.cardType ) {
                        cardFound = true;
                        break;
                    }
                }
                
                if (cardFound) {
                    SwyftNetworkAdapter.request(target: .editPayment(paymentMethod: method),
                            success: { response in
                                if (response.statusCode == 200) {
                                    let resp = String(data:  response.data, encoding: .utf8)!
                                    let paymentResponse = PaymentMethodResponse.init(XMLString: resp)
                                    
                                    if let _ = paymentResponse, let _ = paymentResponse!.cardRef,
                                        paymentResponse!.compareHash() {
                                        
                                        let swyftPaymentMethod = SwyftPaymentMethod()
                                        
                                        swyftPaymentMethod.cardType = cardType
                                        swyftPaymentMethod.last4 = last4
                                        swyftPaymentMethod.cardExpiry = method.cardExpiry
                                        swyftPaymentMethod.token = paymentResponse!.cardRef
                                        
                                        
                                        customer.paymentMethods[paymentResponse!.cardRef!] = swyftPaymentMethod
                                        
                                        if isDefault {
                                            customer.defaultPaymentMethod = paymentResponse!.cardRef!
                                        }
                                        
                                        let update = UpdateCustomer.init(success: { (msg, id) in
                                            DispatchQueue.main.async {
                                                _sucesss?(swyftPaymentMethod)
                                            }
                                        }, fail: {failure in
                                            DispatchQueue.main.async {
                                                _failure?("Unable to update customer profile")
                                            }
                                        })
                                        update.put(key: customer.id!, customer: customer)
                                    } else {
                                        let msg = "Hash verification failed"
                                        print("Edit Payment Method Error: \(msg)")
                                        DispatchQueue.main.async {
                                            failure?(msg)
                                        }
                                    }
                                } else {
                                    var msg : String
                                    if let errorMsg = String(data:  response.data, encoding: .utf8), let errorResp = ErrorResponse.init(XMLString: errorMsg), let _msg = errorResp.errorString {
                                        msg = _msg
                                    } else {
                                        msg = "Failed to parse response"
                                    }
                                    print("Edit Payment Method Error: \(msg)")
                                    DispatchQueue.main.async {
                                        failure?(msg)
                                    }
                                }
                    }, error: { error in
                        print("Edit Payment Method Error: ",error)
                        let msg = error.localizedDescription
                        DispatchQueue.main.async {
                            failure?(msg)
                        }
                    }, failure: { error in
                        print("Edit Payment Method Error: ",error)
                        var msg : String
                        if let _msg = error.errorDescription {
                            msg = _msg
                        } else {
                            msg = "Something went wrong. Please try again"
                        }
                        DispatchQueue.main.async {
                            failure?(msg)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        let msg = "Payment method not registered. To add call add payment method"
                        print("Edit Payment Method Error: \(msg)")
                        failure?(msg)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let msg = "Session Ended. Cannot edit payment method"
                    print("Edit Payment Method Error: \(msg)")
                    failure?(msg)
                }
            }
        }
        
    }
}
