//
//  UserNameView.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/20/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

protocol UserNameViewDelegate: class {
    func onConfirmBtnClicked(userName: String)
    func onCancelBtnClicked()
}

class UserNameView: UIView {

    @IBOutlet weak var userNameDescriptionLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var view: UIView?
    weak var delegate: UserNameViewDelegate?
    
    var blurView: UIVisualEffectView?
    
    deinit {
        self.blurView?.removeFromSuperview()
        self.blurView = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupXib()
    }
    
    private func setupXib() {
        //Load xib for the view
        self.view = UINib(nibName: "UserNameView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        
        self.setupView()
    }
    
    func setupView() {
        
        self.userNameTextField.delegate = self
        self.userNameDescriptionLabel.text = "Please Enter the user name that you will be using. \n(You can change the name anytime)"
        
        self.userNameDescriptionLabel.layer.shadowColor = UIColor.black.cgColor
        self.userNameDescriptionLabel.layer.shadowOpacity = 1
        self.userNameDescriptionLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        //Change the font size accordinf to device type
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            print("Current device is Phone type")
            self.userNameDescriptionLabel.font = self.userNameDescriptionLabel.font.withSize(12.0)
        } else {
            print("Current device is ipad type")
            self.userNameDescriptionLabel.font = self.userNameDescriptionLabel.font.withSize(17.0)
        }
        
        
    }
    
    func setupGradientColorAndShadow(bound: CGRect) {
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        let topColor = self.view!.backgroundColor!
        topColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        let bottomColor = UIColor(displayP3Red: r1*0.8 , green: g1*0.8, blue: b1*0.8, alpha: 1)
        
        let gradientLayer = GradientColorMaker.createGradientColorLayer(topColor: topColor, bottomColor: bottomColor, bound: bound)
        self.view?.layer.insertSublayer(gradientLayer, at: 0)
        self.view?.backgroundColor = UIColor.clear
        self.view?.clipsToBounds = false
        
        gradientLayer.cornerRadius = 15
        
        //Setup shadow
        self.view?.layer.shadowColor = UIColor.black.cgColor
        self.view?.layer.shadowOpacity = 0.8
        self.view?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
    
    @IBAction func onConfirmBtnClicked(_ sender: Any) {
        logger.info("Confirm Button Clicked")
        
        //Make sure the user name isn't empty
        guard let userName = self.userNameTextField.text, userName.isEmpty == false else {
            logger.warning("User Name can't be empty")
    
            self.warningLabel.text = "User name can't be empty"
            self.warningLabel.isHidden = false
            return
        }
        
        self.delegate?.onConfirmBtnClicked(userName: userName)
    }
    
    @IBAction func onCancelBtnClicked(_ sender: Any) {
        self.delegate?.onCancelBtnClicked()
        self.removeFromSuperview()
    }
    
    func addBlurView() {
        //Only can be used after being displayed
        if let presentingView = self.superview {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurView = UIVisualEffectView(effect: blurEffect)
            self.blurView = blurView
            blurView.frame = presentingView.bounds
            presentingView.addSubview(blurView)
            presentingView.bringSubview(toFront: self)
        }
    }
}

extension UserNameView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 > 20 || string.count > 20 {
            return false
        }
        return true
    }
}
