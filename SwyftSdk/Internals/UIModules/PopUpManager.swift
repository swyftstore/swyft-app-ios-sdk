//
//  PopUpManager.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/16/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import UIKit

internal class PopUpManager: NSObject {
    
    static let shared = PopUpManager()
    
    fileprivate var opacityWindow = UIWindow(frame: UIScreen.main.bounds)
    fileprivate var cancelButton = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 60))
    fileprivate var presentedView : UIView?
    fileprivate var viewsQueue = [UIView]()
    var isHidden = true
    var isPending = false
    
    private override init() {
        super.init()
        self.cancelButton.setTitle("Close", for: .normal)
        self.cancelButton.addTarget(self, action: #selector(self.cancelAction(cancelButton:)), for: .touchUpInside)
        
        self.opacityWindow.windowLevel = UIWindow.Level.alert
        self.opacityWindow.makeKeyAndVisible()
        self.opacityWindow.isHidden = true
        self.opacityWindow.addSubview(self.cancelButton)
    }
    
    @objc func cancelAction(cancelButton: UIButton) {
        PopUpManager.dismiss()
    }
    
    class func present(view: UIView, cancelIsHidden: Bool = false, newQueue: Bool = false, _ completionHandler : (()->Void)? = nil) -> [UIView]?{
        self.shared.cancelButton.isHidden = cancelIsHidden
        let viewCache = self.shared.viewsQueue
        if newQueue {
            self.clearPresentedView()
            self.shared.viewsQueue = []
        }
        
        if !self.hasContentToPresent() {
            self.addToManagerView(view: view)
        }
        
        self.shared.viewsQueue.append(view)
        
        if self.shared.isHidden {
            self.hide(false)
        }
        return viewCache
    }
    
    class func setViewQueue(views: [UIView]) {
        self.shared.viewsQueue = views
        for view in views {
            self.addToManagerView(view: view)
        }
    }
    
    
    class func dismiss(_ completionHandler : (()->Void)? = nil) {
        
        if self.hasContentToPresent() {
            self.shared.viewsQueue.removeFirst()
            self.clearPresentedView()
            if self.shared.viewsQueue.count > 0 {
                self.addToManagerView(view: self.shared.viewsQueue.first)
                return
            }
        }
        self.hide(true, {
            if let completion = completionHandler {
                completion()
            }
        })
        
    }
    
    class func hasContentToPresent() -> Bool {
        if self.shared.viewsQueue.isEmpty {
            return false
        }
        return true
    }
    
    class func addToManagerView(view : UIView?) {
        self.shared.presentedView = view
        self.shared.presentedView?.center = self.shared.opacityWindow.center
        self.shared.opacityWindow.addSubview(self.shared.presentedView!)
    }
    
    
    class func hide(_ wantsToHide: Bool, _ completion : (()->Void)? = nil) {
        
        if !self.hasContentToPresent() && !wantsToHide {
            if let completion = completion {
                completion()
            }
            return
        }
        
        var backgroundState: UIViewBackgroundAnimationState = .darken
        if wantsToHide {
            backgroundState = .lighten
        }
        
        self.shared.animateBackgroundTo(state: backgroundState) {
            self.shared.isHidden = wantsToHide
            if let completion = completion {
                completion()
            }
        }
    }
    
    
    
    private class func clearPresentedView() {
        if self.shared.presentedView != nil {
            self.shared.presentedView?.removeFromSuperview()
            self.shared.presentedView = nil
        }
    }
    
    
    
    
    func animateBackgroundTo(state: UIViewBackgroundAnimationState, completion:@escaping () -> Void) {
        
        CATransaction.begin()
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let stateAnimation = CABasicAnimation()
        stateAnimation.keyPath = "backgroundColor"
        stateAnimation.duration = 0.20
        stateAnimation.fillMode = CAMediaTimingFillMode.forwards
        stateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let opacityAnimation = CABasicAnimation()
        opacityAnimation.keyPath = "opacity"
        opacityAnimation.duration = 0.20
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        switch state {
        case .darken:
            self.opacityWindow.isHidden = false
            stateAnimation.fromValue = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
            stateAnimation.toValue = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.70).cgColor
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
            
        case .lighten:
            stateAnimation.fromValue = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.70).cgColor
            stateAnimation.toValue = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            
        }
        groupAnimation.animations = [stateAnimation, opacityAnimation]
        
        CATransaction.setCompletionBlock {
            switch state {
            case .darken:
                break
            case .lighten:
                self.opacityWindow.isHidden = true
            }
            completion()
        }
        self.opacityWindow.layer.add(groupAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    
}
