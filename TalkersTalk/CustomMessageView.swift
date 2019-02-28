//
//  CustomMessageView.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/5/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit

protocol CustomMessageViewDelegate: class {
    func CustomMessageViewCancelClicked()
}

class CustomMessageView: UIView {
    
    @IBOutlet weak var customMessageLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var view: UIView?
    
    weak var delegate: CustomMessageViewDelegate?
    
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
        self.view = UINib(nibName: "CustomMessageView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        
    }
    
    func setCustomMessageLabel(message: String) {
        
        self.customMessageLabel.text = message
        self.customMessageLabel.sizeToFit()
        
        self.topView.layer.borderWidth = 2
        self.topView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func onCancelBtnClicked(_ sender: Any) {
        self.removeFromSuperview()
        self.delegate?.CustomMessageViewCancelClicked()
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
