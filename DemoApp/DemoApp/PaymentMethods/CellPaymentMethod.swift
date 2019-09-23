//
//  CellPaymentMethod.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/18/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit
import SwyftSdk

class CellPaymentMethod: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var isDefaultIcon: UIImageView!
    @IBOutlet weak var editContainer: UIView!

    private var _method: SwyftPaymentMethod?
    
    var method: SwyftPaymentMethod? {
        get {
            return _method
        }
        
        set (m) {
            _method = m
            if let _ = _method, _method!.isDefault {
                isDefaultIcon.image = UIImage(named:"CardDefault")
            } else {
                 isDefaultIcon.image = UIImage(named:"CardNonDefault")
            }
        }
    }
    
    var delegate: UpdateDelegate?
    
    public func addListeners() {
        isDefaultIcon.isUserInteractionEnabled = true
        isDefaultIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(defaultTapped)))
        
        editContainer.isUserInteractionEnabled = true
        editContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editTapped)))
    }
    
    @objc public func defaultTapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let method = self.method else {
            return;
        }
        self.delegate?.showProgress()
        SwyftSdk.setDefaultPaymentMethod(defaultMethod: method, success: { response in
            //update ui to show new default method
            self.delegate?.updateMethods()
        }) { error in
            print(error)
            self.delegate?.hideProgress()
        }
    }
    
    @objc public func editTapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let method = self.method else {
            return;
        }
        self.delegate?.showProgress()
        let fullMethod = FullPaymentMethod(from: method)
        fullMethod.cvv = "111"
        fullMethod.cardNumber = "4111111111112222"
        SwyftSdk.editPaymentMethod(method: fullMethod, success: { response in
            self.delegate?.updateMethods()
            
        }) { error in
            print(error)
            self.delegate?.hideProgress()
        }
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        print("image tapped")
    }
    
    
    
}
