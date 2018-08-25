//
//  SplashScreenViewController.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/20/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    
    weak var userNameView: UserNameView?
    weak var activityView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MessagingResponseAPIs.sharedInstance.serverConnectionDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onConnectBtnClicked(_ sender: Any) {
        logger.info("Connect button was clicked - connect to the server")
        
        //Display the user name view that user will be entering their nick name
        let userNameView = UserNameView(frame: CGRect.zero)
        
        self.view.addSubview(userNameView)
        userNameView.translatesAutoresizingMaskIntoConstraints = false
        userNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userNameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        userNameView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        userNameView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        userNameView.clipsToBounds = true
        userNameView.layer.cornerRadius = 10
        self.userNameView = userNameView
        self.userNameView?.delegate = self
        
    }
    

}

extension SplashScreenViewController: UserNameViewDelegate {
    func onConfirmBtnClicked(userName: String) {
        self.userNameView?.removeFromSuperview()
        SocketConnectionManager.sharedInstance.userName = userName
        
        //Display activity indicator view until the connection is done
        let activityView = CustomActivityIndicatorView(frame: CGRect.zero)
        activityView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        activityView.layer.cornerRadius = 15
        activityView.clipsToBounds = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        activityView.setupLabel(label: "Connecting")
        self.activityView = activityView
        
        TCPConnectionService.sharedInstance.establishTCPConnection()
    }
    
}

extension SplashScreenViewController: ServerConnectionDelegate {
    func onConnectedToServer() {
        logger.info("Server connection was successful")
        
        //Request for updating user name
        MessagingRequestAPIs.sharedInstance.requestForChangeUserName(name: SocketConnectionManager.sharedInstance.userName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.activityView?.removeFromSuperview()
            //display the main lobby view
            ViewControllerRouter.presentMessageLobbyViewController(currentVC: self, withDelay: 0)
        })
    }
}
