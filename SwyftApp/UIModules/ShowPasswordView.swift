//
//  ShowPasswordView.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation


import Foundation
import UIKit

protocol ShowPasswordViewDelegate: class {
    func viewWasToggled(showPasswordView: ShowPasswordView, isSelected selected: Bool)
}

class ShowPasswordView: UIView {
    private let eyeOpenedImage: UIImage
    private let eyeClosedImage: UIImage
    private let eyeButton: UIButton
    weak var delegate: ShowPasswordViewDelegate?
    
    enum EyeState {
        case open
        case closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .open
        }
        get {
            return eyeButton.isSelected ? .open : .closed
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        self.eyeOpenedImage = UIImage(named: "ic_eye_open")!.withRenderingMode(.alwaysTemplate)
        self.eyeClosedImage = UIImage(named: "ic_eye_closed")!
        self.eyeButton = UIButton(type: .custom)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    private func setupViews() {
        let padding: CGFloat = 0
        let buttonWidth = (frame.width / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: frame.height)
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, for: .normal)
        eyeButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonPressed), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
        
    }
    
    
    @objc func eyeButtonPressed(sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(showPasswordView: self, isSelected: eyeButton.isSelected)
    }
}
