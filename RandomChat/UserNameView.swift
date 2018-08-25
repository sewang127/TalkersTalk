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
}

class UserNameView: UIView {

    @IBOutlet weak var userNameDescriptionLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var view: UIView?
    weak var delegate: UserNameViewDelegate?
    
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
        self.userNameDescriptionLabel.text = "Please Enter the user name that you will be using. \n(You can change the name anytime)"
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
    
}
