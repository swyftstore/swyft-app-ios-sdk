//
//  PasswordTextField.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 5/21/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import UIKit

import JVFloatLabeledTextField


class PasswordUITextField: JVFloatLabeledTextField {
    
    var preferredFont: UIFont? {
        didSet {
            self.font = preferredFont
            
            if self.isSecureTextEntry {
                self.font = nil
            }
        }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry {
                self.font = nil
                self.font = preferredFont
            }
        }
    }
    private var showPasswordView: ShowPasswordView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: UITextFieldDelegate needed calls
// Implement UITextFieldDelegate when you use this, and forward these calls to this class!
extension PasswordUITextField {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Hack to prevent text from getting cleared
        // http://stackoverflow.com/a/29195723/1417922
        //Setting the new text.
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        textField.text = updatedString
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.count, 0)
        let from = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)!
        let to = textField.position(from: from, offset:selectedRange.length)!
        textField.selectedTextRange = textField.textRange(from: from, to: to)
        
        //Sending an action
        textField.sendActions(for: .editingChanged)
        
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        showPasswordView.eyeState = ShowPasswordView.EyeState.closed
        self.isSecureTextEntry = !isSelected
    }
}

// MARK: ShowPasswordViewDelegate
extension PasswordUITextField: ShowPasswordViewDelegate {
    func viewWasToggled(showPasswordView: ShowPasswordView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.isSecureTextEntry = !selected
    }
}

// MARK: Private helpers
extension PasswordUITextField {
    private func setupViews() {
        let toggleFrame = CGRect(x: 0, y: 0, width: 66, height: frame.height)
        showPasswordView = ShowPasswordView(frame: toggleFrame)
        showPasswordView.tintColor = Constants.primaryColor
        showPasswordView.delegate = self
        
        self.keyboardType = .asciiCapable
        self.rightView = showPasswordView
        self.rightViewMode = .always
        
        self.font = self.preferredFont
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        // default eye state based on our initial secure text entry
        showPasswordView.eyeState = isSecureTextEntry ? .closed : .open
    }
}
