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
    
    var method: SwyftPaymentMethod?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isDefaultIcon.isUserInteractionEnabled = true
        isDefaultIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(defaultTapped)))

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func defaultTapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let method = self.method else {
            return;
        }
        
        SwyftSdk.setDefaultPaymentMethod(defaultMethod: method, success: { response in
            //update ui to show new default method
        }) { error in
            print(error)
        }
    }
    
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isDefaultIcon.isUserInteractionEnabled = true
//        isDefaultIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
//    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        print("image tapped")
    }
    
    
    
}
