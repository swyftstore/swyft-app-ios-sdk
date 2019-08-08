//
//  RemovePaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/28/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class RemovePaymentInteractor {
    
    public static func removePaymentMethod(removeMethod: RemovePaymentMethod,
                                 success:SwyftConstants.removePaymentSuccess,
                                 failure: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session, let customer = session.customer {
             
                let _sucesss = success
                let _failure = failure
                var swyftMethod: SwyftPaymentMethod?
               
                if let token = removeMethod.cardRef {
                    swyftMethod = customer.paymentMethods[token]
                }
                
                if let _ = swyftMethod {
                    SwyftNetworkAdapter.request(target: .removePayment(paymentMethod: removeMethod),
                        success: { response in
                            let resp = String(data:  response.data, encoding: .utf8)!
                            if (response.statusCode == 200 && !resp.contains("ERRORSTRING")) {
                                debugPrint("payment response: ",resp)
                                let paymentResponse = RemoveMethodResponse.init(XMLString: resp)
                                paymentResponse?.cardRef = removeMethod.cardRef
                                if let _ = paymentResponse,
                                    paymentResponse!.compareHash() {
                                    let token = removeMethod.cardRef;
                                    customer.paymentMethods.removeValue(forKey: token!)
                                   
                                    let update = UpdateCustomer.init(success: { (msg, id) in
                                        DispatchQueue.main.async {
                                            _sucesss?()
                                        }
                                    }, fail: {failure in
                                        DispatchQueue.main.async {
                                            _failure?("Unable to update customer profile")
                                        }
                                    })
                                    var data : [String: Any] = [:]
                                    var pMethods : [String: Any] = [:]
                                    pMethods[token!] = FieldValue.delete()
                                    if customer.paymentMethods.isEmpty {
                                        data["defaultPaymentMethod"] = FieldValue.delete()
                                    } else if customer.defaultPaymentMethod == token {
                                        var interator = customer.paymentMethods.makeIterator()
                                        let pMethod = interator.next();
                                        data["defaultPaymentMethod"] = pMethod?.value.token
                                    }
                                    data["paymentMethods"] = pMethods
                                    update.put(key: customer.id!, data: data)
                                } else {
                                    let msg = "Hash verification failed"
                                    print("Add Payment Method Error: \(msg)")
                                    DispatchQueue.main.async {
                                        failure?(msg)
                                    }
                                }
                            } else {                               
                                errorHandler(errorMsg: resp, failure: failure)
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
    
    private static func errorHandler(errorMsg: String, failure: SwyftConstants.fail) {
        var msg : String
        if let errorResp = ErrorResponse.init(XMLString: errorMsg), let _msg = errorResp.errorString {
            msg = _msg
        } else {
            msg = "Failed to parse response"
        }
        print("Remove Payment Method Error: \(msg)")
        DispatchQueue.main.async {
            failure?(msg)
        }
    }
}
