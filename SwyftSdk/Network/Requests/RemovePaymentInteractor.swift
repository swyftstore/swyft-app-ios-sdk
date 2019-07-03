//
//  RemovePaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation

public class RemovePaymentInteractor {
    
    public func removePaymentMethod(removeMethod: RemovePaymentMethod,
                                 success:SwyftConstants.removePaymentSuccess,
                                 failure: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session, let customer = session.customer {
             
                let _sucesss = success
                let _failure = failure
                var swyftMethod: SwyftPaymentMethod?
                var index = 0;
                for method in customer.paymentMethods {
                    if ( method.token ==  removeMethod.cardRef) {
                        swyftMethod = method;
                        index = index + 1
                        break;
                    }
                }
                
                if let _ = swyftMethod {
                    SwyftNetworkAdapter.request(target: .removePayment(paymentMethod: removeMethod),
                        success: { response in
                            if (response.statusCode == 200) {
                                let resp = String(data:  response.data, encoding: .utf8)!
                                let paymentResponse = RemoveMethodResponse.init(XMLString: resp)
                                if let _ = paymentResponse,
                                    paymentResponse!.compareHash() {
                                    customer.paymentMethods.remove(at: index)
                                        
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
                                    let msg = "Hash verification failed"
                                    print("Add Payment Method Error: \(msg)")
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
                                print("Remove Payment Method Error: \(msg)")
                                DispatchQueue.main.async {
                                    failure?(msg)
                                }
                            }
                    }, error: { error in
                        print("Remove Payment Method Error: ",error)
                        let msg = error.localizedDescription
                        DispatchQueue.main.async {
                            failure?(msg)
                        }
                    }, failure: { error in
                        print("Remove Payment Method Error: ",error)
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
                        let msg = "Payment Method Not registered."
                        print("Remove Payment Method Error: \(msg)")
                        failure?(msg)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let msg = "Session Ended. Cannot add payment method"
                    print("Remove Payment Method Error: \(msg)")
                    failure?(msg)
                }
            }
        }
        
    }
}
