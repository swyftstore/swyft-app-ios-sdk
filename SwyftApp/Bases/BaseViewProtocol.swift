//
//  BaseViewProtocol.swift
//  customer
//
//  Created by Tom Manuel on 5/16/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import UIKit


protocol BaseViewProtocol: class {
    typealias Completion = (()->Void)?
    
    func showAlert(title: String, message: String, okAction:Completion)
    func showError(errorMsg: String, completion: Completion)
    func showError(errorMsg: String, delayTime: Double, completion:Completion)
    func showError(errorMsg: String, delayTime: Double, view: UIView?, completion:Completion)
    func showLoadingHud(message: String, view: UIView)
    func showLoadingHud(message: String)
    func hideLoadingHud()
}
