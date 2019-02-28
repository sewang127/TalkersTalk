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
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    
    weak var userNameView: UserNameView?
    weak var eulaView: EULAView?
    weak var contactInfoView: CustomMessageView?
    weak var activityView: UIView?
    weak var backgroundView: UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MessagingResponseAPIs.sharedInstance.serverConnectionDelegate = self
        
        self.setupKeyboardNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Set gradient color for connectButton
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var topColor = self.connectButton.backgroundColor!
        topColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        var bottomColor = UIColor(displayP3Red: r1*0.8 , green: g1*0.8, blue: b1*0.8, alpha: 1)
        
        let gradientLayer = GradientColorMaker.createGradientColorLayer(topColor: topColor, bottomColor: bottomColor, bound: self.connectButton.bounds)
        self.connectButton.backgroundColor = .clear
        self.connectButton.layer.insertSublayer(gradientLayer, at: 0)
        
        //Rotate the logo label 20 degree
        self.logoLabel.transform = CGAffineTransform(rotationAngle: (CGFloat.pi * -10.0 / 180.0))
        
        
        if self.backgroundView == nil {
            //Add a background view
            let backgroundView = UIView(frame: .zero)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(backgroundView)
            self.view.bringSubview(toFront: logoImageView)
            self.backgroundView = backgroundView
            
            //Setting constraint
            let xOffset: CGFloat = 2.5
            let yOffset: CGFloat = -5.0
            backgroundView.centerXAnchor.constraint(equalTo: self.logoImageView.centerXAnchor, constant: xOffset).isActive = true
            backgroundView.centerYAnchor.constraint(equalTo: self.logoImageView.centerYAnchor, constant: yOffset).isActive = true
            let backgroundWidth = self.logoImageView.frame.width * 1.3
            let backgroundHeight = self.logoImageView.frame.height * 1.3
            backgroundView.widthAnchor.constraint(equalToConstant: backgroundWidth).isActive = true
            backgroundView.heightAnchor.constraint(equalToConstant: backgroundHeight).isActive = true
            
            self.view.layoutIfNeeded()
            backgroundView.backgroundColor = .clear
            topColor = UIColor(displayP3Red: 255.0/255.0, green: 190.0/255.0, blue: 120.0/255.0, alpha: 1)
            topColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            bottomColor = UIColor(displayP3Red: r1*0.8 , green: g1*0.8, blue: b1*0.8, alpha: 1)
            let viewBound = CGRect(x: xOffset, y: yOffset, width: backgroundView.bounds.width, height: backgroundView.bounds.height)
            let gradientLayerForBackground = GradientColorMaker.createGradientColorLayer(topColor: topColor, bottomColor: bottomColor, bound: viewBound)
            gradientLayerForBackground.cornerRadius = gradientLayerForBackground.frame.height / 2
            backgroundView.layer.insertSublayer(gradientLayerForBackground, at: 0)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Keyboard notification
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil);
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero).size.height
        
        if let userNameView = self.userNameView {
            let nameViewOffset = self.view.frame.height - userNameView.frame.maxY
            if nameViewOffset < keyboardHeight {
                //keyboard is hiding the name view, so shift the name view upwards
                self.view.constraints.forEach({
                    if $0.identifier == "yAnchor" {
                        $0.constant -= (keyboardHeight - nameViewOffset) + 10
                        print("Constraint cneter y updated")
                    }
                })
            }
        }
    }
    
    @IBAction func onConnectBtnClicked(_ sender: Any) {
        logger.info("Connect button was clicked - connect to the server")
        
        //First Make sure if user has agreed with eula
        let isEULARead = UserDefaults.standard.value(forKey: "isEULARead") as? Bool
        if isEULARead == nil || isEULARead! == false {
            
            //Display EULA View
            let eulaView = EULAView(frame: CGRect.zero)
            self.view.addSubview(eulaView)
            
            eulaView.translatesAutoresizingMaskIntoConstraints = false
            eulaView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            eulaView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            eulaView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
            eulaView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
            eulaView.delegate = self
            
            self.eulaView = eulaView
            
        } else {
            //Display the user name view that user will be entering their nick name
            let userNameView = UserNameView(frame: CGRect.zero)
            
            self.view.addSubview(userNameView)
            userNameView.translatesAutoresizingMaskIntoConstraints = false
            userNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            let yAnchor = userNameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            yAnchor.identifier = "yAnchor"
            yAnchor.isActive = true
            userNameView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
            userNameView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            self.userNameView = userNameView
            self.userNameView?.delegate = self
            
            let layerBound = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 200)
            self.userNameView?.setupGradientColorAndShadow(bound: layerBound)
            
        }
        self.connectButton.isUserInteractionEnabled = false
        self.contactButton.isUserInteractionEnabled = false
        self.eulaButton.isUserInteractionEnabled = false
    }
    
    func resetUIComponents() {
        self.userNameView?.removeFromSuperview()
        self.activityView?.removeFromSuperview()
        self.userNameView = nil
        self.activityView = nil
        
        self.connectButton.isUserInteractionEnabled = true
        self.contactButton.isUserInteractionEnabled = true
        self.eulaButton.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        logger.info("UI Components were reset")
    }
    
    @IBAction func onContactBtnClicked(_ sender: Any) {
        //Display ContactInfo View
        
        let contactInfoView = CustomMessageView(frame: CGRect.zero)
        contactInfoView.setCustomMessageLabel(message: Constants.contactInfoMessage)
        
        self.view.addSubview(contactInfoView)
        
        contactInfoView.translatesAutoresizingMaskIntoConstraints = false
        contactInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contactInfoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        contactInfoView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        contactInfoView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        contactInfoView.delegate = self
        
        self.contactInfoView = contactInfoView
        
        self.connectButton.isUserInteractionEnabled = false
        self.contactButton.isUserInteractionEnabled = false
        self.eulaButton.isUserInteractionEnabled = false
    }
    
    @IBAction func onEULABtnClicked(_ sender: Any) {
        //Display EULA View
        let eulaView = EULAView(frame: CGRect.zero)
        eulaView.loadEULA(viewOnly: true)
        self.view.addSubview(eulaView)
        
        eulaView.translatesAutoresizingMaskIntoConstraints = false
        eulaView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eulaView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        eulaView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        eulaView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        eulaView.delegate = self
        
        self.eulaView = eulaView
        
        self.connectButton.isUserInteractionEnabled = false
        self.contactButton.isUserInteractionEnabled = false
        self.eulaButton.isUserInteractionEnabled = false
    }
    
}

extension SplashScreenViewController: UserNameViewDelegate {
    func onCancelBtnClicked() {
        self.connectButton.isUserInteractionEnabled = true
        self.contactButton.isUserInteractionEnabled = true
        self.eulaButton.isUserInteractionEnabled = true
    }
    
    func onConfirmBtnClicked(userName: String) {
        self.userNameView?.removeFromSuperview()
        SocketConnectionManager.sharedInstance.userName = userName
        
        //Display activity indicator view until the connection is done
        let activityView = CustomActivityIndicatorView(frame: CGRect.zero)
        activityView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
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
        
        self.connectButton.isUserInteractionEnabled = true
        self.contactButton.isUserInteractionEnabled = true
        self.eulaButton.isUserInteractionEnabled = true
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

extension SplashScreenViewController: EULAViewDelegate {
    func onAgreeClicked() {
        self.eulaView?.removeFromSuperview()
        self.eulaView = nil
        UserDefaults.standard.setValue(true, forKey: "isEULARead")
        self.onConnectBtnClicked(self.connectButton)
        
    }
    
    func onCancelClicked() {
        self.eulaView?.removeFromSuperview()
        self.eulaView = nil
        self.connectButton.isUserInteractionEnabled = true
        self.contactButton.isUserInteractionEnabled = true
        self.eulaButton.isUserInteractionEnabled = true
    }
}

extension SplashScreenViewController: CustomMessageViewDelegate {
    func CustomMessageViewCancelClicked() {
        self.contactInfoView?.removeFromSuperview()
        self.contactInfoView = nil
        self.connectButton.isUserInteractionEnabled = true
        self.contactButton.isUserInteractionEnabled = true
        self.eulaButton.isUserInteractionEnabled = true
    }
}
