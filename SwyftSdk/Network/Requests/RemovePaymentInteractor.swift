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
                            debugPrint("payment response: ",resp)
                            if (response.statusCode == 200 && !resp.contains("ERRORSTRING")) {
                                let paymentResponse = RemoveMethodResponse.init(XMLString: resp)
                                paymentResponse?.cardRef = removeMethod.cardRef
                                if let _ = paymentResponse,
                                    paymentResponse!.compareHash() {
                                    removeFromDB(token: paymentResponse!.cardRef, customer: customer, success: _sucesss, failure: _failure)
                                } else {
                                    let msg = "Hash verification failed"
                                    print("Remove Payment Method Error: \(msg)")
                                    removeFromDB(token: paymentResponse!.cardRef, customer: customer, success: _sucesss, failure: _failure)
                                }
                            } else {
                                let errorResponse = ErrorResponse.init(XMLString: resp)
                                let msg: String
                                if let error = errorResponse?.errorString {
                                    msg = "Remove Payment Method Error: \( error)"
                                } else {
                                    msg = "Remove Payment Method Error: Unknown Error"
                                }
                                print(msg)
                                removeFromDB(token: removeMethod.cardRef, customer: customer, success: _sucesss, failure: _failure)
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
    
    private static func removeFromDB(token: String?,
                                     customer: Customer,
                                     success: SwyftConstants.removePaymentSuccess,
                                     failure: SwyftConstants.fail) {
    
        if let token = token {
            customer.paymentMethods.removeValue(forKey: token)
            
            let update = UpdateCustomer.init(success: { (msg, id) in
                DispatchQueue.main.async {
                     success?()
                }
            }, fail: {_failure in
                DispatchQueue.main.async {
                    failure?("Unable to update customer profile")
                }
            })
            var data : [String: Any] = [:]
            var pMethods : [String: Any] = [:]
            pMethods[token] = FieldValue.delete()
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
            DispatchQueue.main.async {
                failure?("Unable to update customer profile")
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
