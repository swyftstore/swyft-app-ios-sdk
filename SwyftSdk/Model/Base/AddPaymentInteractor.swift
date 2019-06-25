//
//  AddPaymentInteractor.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 6/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


public class AddPaymentInteractor {
    
    public func addPaymentMethod(method: PaymentMethod, isDefault: Bool,
                                 success:SwyftConstants.addPaymentSuccess, fail: SwyftConstants.fail) {
        DispatchQueue.global(qos: .background).async {
            if let session = Configure.current.session, let customer = session.customer {
                let last4 = method.last4
                let cardType = method.cardType
                let _sucesss = success
                let _fail = fail
                
                var cardFound = false
                
                for method in customer.paymentMethods {
                    if ( last4 ==  method.last4 && cardType == method.cardType ) {
                        DispatchQueue.main.async {
                            _fail?("Card already registerd, to update call update payment method")
                        }
                        cardFound = true;
                        break;
                        
                    }
                }
        
                if (!cardFound) {
                    SwyftNetworkAdapter.request(target: .addPayment(paymentMethod: method), success: { response in
                        if (response.statusCode == 200) {
                            let resp = String(data:  response.data, encoding: .utf8)!
                            let paymentResponse = PaymentResponse.init(XMLString: resp)
                            let swyftPaymentMethod = SwyftPaymentMethod()
                            swyftPaymentMethod.cardType = method.cardType
                            swyftPaymentMethod.last4 = method.last4
                            swyftPaymentMethod.cardExpiry = method.cardExpiry
                            swyftPaymentMethod.isDefault = false
                            swyftPaymentMethod.token = paymentResponse?.cardRef
                            customer.paymentMethods.append(swyftPaymentMethod)
                            let update = UpdateCustomer.init(success: { (msg, id) in
                                DispatchQueue.main.async {
                                    _sucesss?(swyftPaymentMethod)
                                }
                            }, fail: {failure in
                                DispatchQueue.main.async {
                                    _fail?("Unable to update customer profile")
                                }
                            })
                            update.put(key: customer.id!, customer: customer)
                        } else {
                            var msg : String
                            if let errorMsg = String(data:  response.data, encoding: .utf8), let errorResp = ErrorResponse.init(XMLString: errorMsg) {
                                msg = errorResp.errorString
                            } else {
                                msg = "Failed to parse response"
                            }
                            DispatchQueue.main.async {
                                _fail?(msg)
                            }
                        }
                    }, error: { error in
                        print(error)
                        let msg = error.localizedDescription
                        DispatchQueue.main.async {
                            fail?(msg)
                        }
                    }, failure: { error in
                        print(error)
                        var msg : String
                        if let _msg = error.errorDescription {
                           msg = _msg
                        } else {
                            msg = "Something went wrong, please try again"
                        }
                        DispatchQueue.main.async {
                            fail?(msg)
                        }
                    })
                }
            } else {
                DispatchQueue.main.async {
                    fail?("Session Ended, can not add card")
                }
            }
        }
    
    }
}
