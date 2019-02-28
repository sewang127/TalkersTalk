//
//  EULAView.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/4/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit
import WebKit

protocol EULAViewDelegate: class {
    
    func onCancelClicked()
    func onAgreeClicked()
    
}

class EULAView: UIView {
    
    @IBOutlet weak var eulaWebView: WKWebView!
    @IBOutlet weak var agreeButton: UIButton!
    
    var view: UIView?
    
    weak var delegate: EULAViewDelegate?
    
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
        self.view = UINib(nibName: "EULAView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        
        self.loadEULA(viewOnly: false)
    }
    
    func loadEULA(viewOnly: Bool) {
        let docURL = Bundle.main.url(forResource: "eula", withExtension: "docx")
        let urlRequest = URLRequest(url: docURL!)
        
        self.eulaWebView.layer.borderColor = UIColor.black.cgColor
        self.eulaWebView.layer.borderWidth = 2
        self.view?.clipsToBounds = true
        self.view?.layer.cornerRadius = 10
        
        self.eulaWebView.load(urlRequest)
        
        if viewOnly {
            self.agreeButton.isHidden = true
        } else {
            self.agreeButton.isHidden = false
        }
        
    }
    
    @IBAction func onCancelBtnClicked(_ sender: Any) {
        self.delegate?.onCancelClicked()
        self.removeFromSuperview()
    }
    
    @IBAction func onAgreeBtnClicked(_ sender: Any) {
        self.delegate?.onAgreeClicked()
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
