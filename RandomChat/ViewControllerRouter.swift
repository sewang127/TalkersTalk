//
//  ViewControllerRouter.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/21/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class ViewControllerRouter {
    
    static func presentMessageLobbyViewController(currentVC: UIViewController, withDelay: TimeInterval) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MessageLobbyViewController")
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay, execute: {
            currentVC.present(vc, animated: true, completion: nil)
        })
    }
    
    static func presentMessageChatRoomViewController(currentVC: UIViewController, withDelay: TimeInterval) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MessageRoomViewController")
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay, execute: {
            currentVC.present(vc, animated: true, completion: nil)
        })
        
    }
    
    static func getTopDisplayingVC() -> UIViewController {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    static func moveToSplashScreen(currentVC: UIViewController) {
        
        func dismissVC(vc: UIViewController, completionHandler: @escaping (UIViewController?)->()) {
            if let presentingVC = vc.presentingViewController {
                vc.dismiss(animated: true, completion: {
                    completionHandler(presentingVC)
                })
            }
        }
        
        var rootVC = currentVC
        
        while rootVC.presentingViewController != nil {
            rootVC = rootVC.presentingViewController!
        }
        logger.info("Dismiss all modally presented view controllers and go to splash screen vc")
        rootVC.dismiss(animated: false, completion: nil)
        
        if let splashVC = rootVC as? SplashScreenViewController {
            splashVC.resetUIComponents()
        }
    }
    
    static func displayAlertController(title: String, message: String, blockToExecute: @escaping (_ currentVC: UIViewController)->()) {
        
        let topVC = self.getTopDisplayingVC()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            blockToExecute(topVC)
        })
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            topVC.present(alertController, animated: false, completion: nil)
        }
    }
    
}
