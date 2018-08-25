//
//  MessageLobbyViewController.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/2/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class MessageLobbyViewController: UIViewController {

    @IBOutlet weak var connectedUserNumberLabel: UILabel!
    
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var connectionStateLabel: UILabel!
    
    var connectionTimer: Timer?
    
    weak var userNameView: UserNameView?
    weak var activityIndicatorView: UIView?
    
    deinit {
        print("MessageLobbyViewController is being deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //When the view appears, setup the labels
        MessagingResponseAPIs.sharedInstance.lobbyDelegate = self
        self.sendRequestForGettingUserNum()
        self.resetLobbyUI(resetLabels: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MessagingResponseAPIs.sharedInstance.lobbyDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConnectBtnClicked(_ sender: Any) {
        
        logger.info("Connect button was clicked - current state: \(String(describing: self.connectionButton.titleLabel?.text))")
        
        if self.connectionButton.titleLabel!.text == Constants.MessageLobbyViewLabels.ConnectionButtonMatch.rawValue {
            
            //Connect to the server and match a random user for chatting
            MessagingRequestAPIs.sharedInstance.requestForConnectingChatRoom()
            self.connectionButton.setTitle(Constants.MessageLobbyViewLabels.ConnectionButtonCancel.rawValue, for: UIControlState.normal)
            self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelMatching.rawValue
            
            
        } else if self.connectionButton.titleLabel!.text == Constants.MessageLobbyViewLabels.ConnectionButtonCancel.rawValue {
            //Cancel the request
            
            MessagingRequestAPIs.sharedInstance.requestForCancelingConnectionChatRoom()
            
        }
        
    }
    
    @IBAction func onUserNumReloadClicked(_ sender: Any) {
        logger.info("User Num is being reloaded")
        self.sendRequestForGettingUserNum()
    }
    
    @IBAction func onChangeNameBtnClicked(_ sender: Any) {
        logger.info("Change Name button was clicked")
        
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
    
    private func sendRequestForGettingUserNum() {
        
        //Display the activity indicator view while the request is going through
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
        
        activityView.setupLabel(label: "Waiting...")
        self.activityIndicatorView = activityView
        
        self.view.isUserInteractionEnabled = false
        MessagingRequestAPIs.sharedInstance.requestForGettingUserNum()
        
    }
    
    private func resetLobbyUI(resetLabels: Bool) {
        self.connectionButton.setTitle(Constants.MessageLobbyViewLabels.ConnectionButtonMatch.rawValue, for: UIControlState.normal)
        self.connectionButton.isUserInteractionEnabled = true
        if resetLabels {
            self.connectionStateLabel.text = ""
        }
    }
}

//MARK: Response Delegate
extension MessageLobbyViewController: MessageLobbyResponseDelegate {
    func onReceivingUserNum(num: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view.isUserInteractionEnabled = true
            self.connectedUserNumberLabel.text = String(num)
            self.activityIndicatorView?.removeFromSuperview()
        })
    }
    
    func onCancelingChatRoomConnection() {
        //Cancel the timer and reset the labels
        self.connectionTimer?.invalidate()
        if self.connectionStateLabel!.text == Constants.MessageLobbyViewLabels.ConnectionLabelRetry.rawValue {
            self.resetLobbyUI(resetLabels: false)
        } else {
            self.resetLobbyUI(resetLabels: true)
        }
        
    }
    
    func onJoiningChatRoomStatus(status: Constants.MessagingResponseStatus, error: Constants.MessagingJoiningChatRoomResponseError?) {
        //Joining chat room status
        logger.info("chat room status response - status: \(status), error: \(String(describing: error))")
        
        if status == .Success {
            //Joined a chat room succeeded, now move to the chat room screen.
            
            self.connectionTimer?.invalidate()
            self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelMatchFound.rawValue
            self.connectionButton.isUserInteractionEnabled = false
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageRoomViewController") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        
                        self.present(vc, animated: true, completion: nil)
                    })
                    
                } else {
                    logger.error("Message Chat Room VC failed to be fetched...This shouldn't happen!!!!")
                    assert(true)
                }
                
            })
            
        } else {
            //Status failed
            logger.error("Chat room join failed due to error code: \(error?.rawValue ?? "")")
            if let error = error, error == .NoMatchFound {
                //No match found
                self.connectionButton.setTitle(Constants.MessageLobbyViewLabels.ConnectionButtonCancel.rawValue, for: UIControlState.normal)
                
                self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue
                
                var timerExecutions = 0
                //animating text change to show UI is ongoing
                connectionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                    
                    if self.connectionStateLabel.text == Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue {
                        self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue + "."
                    } else if self.connectionStateLabel.text == Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue + "." {
                        self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue + ".."
                    } else if self.connectionStateLabel.text == Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue + ".." {
                        self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue + "..."
                    } else {
                        self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelWaiting.rawValue
                    }
                    
                    timerExecutions += 1
                    
                    if timerExecutions > 40 {
                        //Invalidate timer after waiting for 20 sec
                        print("Timer will be stopped")
                        timer.invalidate()
                        self.resetLobbyUI(resetLabels: true)
                        self.connectionStateLabel.text = Constants.MessageLobbyViewLabels.ConnectionLabelRetry.rawValue
                        MessagingRequestAPIs.sharedInstance.requestForCancelingConnectionChatRoom()
                    }
                    
                })
                
            }
        }
    }
}

extension MessageLobbyViewController: UserNameViewDelegate {
    func onConfirmBtnClicked(userName: String) {
        logger.info("User name change confirm button clicked")
        self.userNameView?.removeFromSuperview()
        SocketConnectionManager.sharedInstance.userName = userName
        
        //Request for updating user name
        MessagingRequestAPIs.sharedInstance.requestForChangeUserName(name: SocketConnectionManager.sharedInstance.userName)
        
    }
    
}
