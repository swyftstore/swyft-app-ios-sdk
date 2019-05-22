//
//  BaseVC.swift
//  customer
//
//  Created by Tom Manuel on 5/15/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import SwyftSdk
import MBProgressHUD

class BaseVC: UIViewController, BaseViewProtocol {
    var hud : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwyftSdk.Configure.setSession(sesssion: Session.currentSession)
    }
    
    func showAlert(title: String, message: String, okAction: Completion) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: ""), message:NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: { (UIAlertAction) -> Void in
            if let _okAction = okAction {
                _okAction()
            }
        }))
        
        DispatchQueue.main.async {
            if PopUpManager.hasContentToPresent() {
                PopUpManager.hide(true,{ () in
                    self.present(alert, animated: true, completion: {() in
                        //       PopUpManager.hide(false)
                    })
                })
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showError(errorMsg: String, completion: Completion) {
        showError(errorMsg: errorMsg, delayTime: 2.0, view: nil, completion: completion)
    }
    
    func showError(errorMsg: String, delayTime: Double, completion:Completion){
        showError(errorMsg: errorMsg, delayTime: delayTime, view: nil, completion: completion)
    }
    
    func showError(errorMsg: String, delayTime: Double, view: UIView? = nil, completion: Completion) {
        DispatchQueue.main.async {
            let _view : UIView
            if let _ = view {
                _view = view!
            } else {
                _view = self.view
            }
            _ = ProgressHud.displayMessage(errorMsg, fromView: _view, delayTime: delayTime, completion: completion)
        }
    }
    
    func showLoadingHud(message: String) {
        showLoadingHud(message: message, view: self.view)
    }
    
    
    func showLoadingHud(message: String, view: UIView) {
        DispatchQueue.main.async {
            if let hidden = self.hud?.isHidden {
                if (hidden) {
                    self.hud = ProgressHud.displayProgress(message, fromView: view)
                    self.hud?.isHidden = false
                }
            } else {
                self.hud = ProgressHud.displayProgress(message, fromView:view)
                self.hud?.isHidden = false
            }
        }
    }
    
    func hideLoadingHud() {
        DispatchQueue.main.async {
            self.hud?.isHidden = true
            self.hud?.hide(animated: true)
        }
    }
}


