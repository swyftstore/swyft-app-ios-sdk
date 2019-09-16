//
//  MBProgressHud.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/16/19.
//  Copyright © 2019 Swyft. All rights reserved.
//
import UIKit
import MBProgressHUD

class ProgressHud: NSObject {
    //    private var hud : UIView?
    
    class func displayMessage(_ text: String?, fromView : UIView?, mode : MBProgressHUDMode = .text, delayTime : Double = 1, completion : (() -> Void)? = nil) -> MBProgressHUD?{
        
        if let fromView = fromView, let text = text {
            let hud = MBProgressHUD.showAdded(to: fromView, animated: true)
            hud.layer.zPosition = 1
            hud.mode = mode
            hud.detailsLabel.text = NSLocalizedString(text, comment: "")
            hud.detailsLabel.font = hud.label.font
            DispatchQueue.main.asyncAfter(deadline:(.now() + delayTime), execute: {
                hud.hide(animated: true)
                if (completion != nil){
                    completion!()
                }
            })
           
            return hud
        }
        return nil
    }
    
    class func displayProgress(_ text: String?, fromView : UIView?, completion : (() -> Void)? = nil) -> MBProgressHUD?{
        
        return self.displayMessage(text, fromView: fromView, mode: .indeterminate, delayTime: 60, completion: completion)
    }
}

