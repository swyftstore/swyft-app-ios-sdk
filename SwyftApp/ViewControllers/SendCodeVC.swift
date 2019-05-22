//
//  SendCodeVC.swift
//  customer
//
//  Created by Tom Manuel on 5/8/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

import SwyftSdk


class SendCodeVC: BaseVC, SendCodeProtocol {
    
    var presenter: SendCodePresenter?
    
    func success(msg: String, segue: String?) {
        debugPrint(msg)
        self.hideLoadingHud()
        if let _segue = segue {
            performSegue(withIdentifier: _segue, sender: nil)
        }
    }
    
    func failure(msg: String) {
        debugPrint(msg)
        self.hideLoadingHud()
        showError(errorMsg: msg, completion: nil)
    }
    
    func validation() -> Bool {
        //todo: handle validation
        return true
    }
    
    func handleNext() {
        self.view.endEditing(true)
        if var code = self.codeInputField?.text {
            code = code.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
            presenter?.sendActivationCodeHandler(code: code)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var codeInputField: UITextField?
    @IBOutlet weak var resendCodeBtn: UIButton?
    @IBOutlet weak var nextBtn: UIButton?
    
    @IBAction func backButton(_ sender: Any) {
        self.view.endEditing(true)
        Session.signOut()
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        handleNext()
    }
    
    @IBAction func resentCodeClicked(_ sender: Any) {
        presenter?.resendCodeHandler()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter = SendCodePresenter(delegate: self)
       
    }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews();
    }
    
    private func setupViews() {
        if let fName = Session.currentSession.customer?.firstName {
            let title = NSLocalizedString("SendCodeTitle", comment: "")
            let next = NSLocalizedString("SendCodeNext", comment: "")
            let sendCodePlaceHolder = NSLocalizedString("SendCodePlaceHolder", comment: "")
            let resendCode = NSLocalizedString("SendCodeResendCode", comment: "")
            
            self.titleLabel?.text = title
            self.codeInputField?.placeholder = sendCodePlaceHolder
            self.codeInputField?.addDashedBottomBoarder(color: Constants.floatPlaceholderColor)

            self.resendCodeBtn?.setTitle(resendCode, for: .normal)
            self.nextBtn?.setTitle(next, for: .normal)
            self.descLabel?.text = String.init(format: NSLocalizedString("SendCodeDesc", comment: "Activation Code Description"), fName)
        } else {
            let msg =  NSLocalizedString("SendCodeGeneralError", comment: "")
            showError(errorMsg: msg, completion: {() in
                Session.signOut()
            })
        }
    }
}
