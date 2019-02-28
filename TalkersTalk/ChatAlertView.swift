//
//  ChatAlertView.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/11/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit

class ChatAlertView: UIAlertController {
    
    var blurView: UIVisualEffectView?
    
    deinit {
        self.blurView?.removeFromSuperview()
        self.blurView = nil
    }
    
    convenience init(viewModel: AlertMenuViewPresentable, title: String?, message: String?, preferredStyle: UIAlertControllerStyle) {
        
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        let actions = viewModel.getMenuActions()
        
        actions.forEach({ self.addAction($0) })
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        self.blurView = blurView
        
    }
    
    //Needs to be called only after the alert view is displayed
    func addBlurEffect() {
        if let presentingVC = self.presentingViewController, let blurView = self.blurView {
            blurView.frame = presentingVC.view.bounds
            presentingVC.view.addSubview(blurView)
        }
    }
    
}


