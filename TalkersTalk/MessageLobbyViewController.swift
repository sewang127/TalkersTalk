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
    @IBOutlet weak var currentNameLabel: UILabel!
    
    var connectionTimer: Timer?
    
    weak var userNameView: UserNameView?
    weak var activityIndicatorView: UIView?
    
    deinit {
        print("MessageLobbyViewController is being deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupKeyboardNotification()
        
        let topColor = UIColor(displayP3Red: 246.0/255.0, green: 161.0/255.0, blue: 45.0/255.0, alpha: 1)
        let bottomColor = UIColor(displayP3Red: 230.0/255.0, green: 100.0/255.0, blue: 10.0/255.0, alpha: 1)
        
        self.connectionButton.backgroundColor = UIColor.clear
        let gradientLayer = GradientColorMaker.createGradientColorLayer(topColor: topColor, bottomColor: bottomColor, bound: self.connectionButton.bounds)
        self.connectionButton.layer.addSublayer(gradientLayer)
        self.connectionButton.layer.cornerRadius = 15
        self.connectionButton.clipsToBounds = true
        
        self.currentNameLabel.text = Constants.MessageLobbyUIWording.CurrentName(name: SocketConnectionManager.sharedInstance.userName)
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
    
    @IBAction func onMenuButtonClicked(_ sender: Any) {
        
        let lobbyMenuViewModel = LobbyAlertMenuViewModel()
        lobbyMenuViewModel.delegate = self
        let alertView = ChatAlertView(viewModel: lobbyMenuViewModel, title: "Menu", message: "Select an option", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertView.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        alertView.popoverPresentationController?.sourceView = self.view
        alertView.popoverPresentationController?.sourceRect = self.view.bounds
        
        self.present(alertView, animated: true, completion: {
            alertView.addBlurEffect()
        })
        
    }
    
    private func sendRequestForGettingUserNum() {
        
        //Display the activity indicator view while the request is going through
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
        
        activityView.setupLabel(label: "Waiting...")
        self.activityIndicatorView = activityView
        
        self.view.isUserInteractionEnabled = false
        MessagingRequestAPIs.sharedInstance.requestForGettingUserNum()
        
    }
    
    private func resetLobbyUI(resetLabels: Bool) {
        self.connectionButton.setTitle(Constants.MessageLobbyViewLabels.ConnectionButtonMatch.rawValue, for: UIControlState.normal)
        self.connectionButton.isEnabled = true
        self.connectionButton.alpha = 1
        if resetLabels {
            self.connectionStateLabel.text = ""
        }
        
        self.connectionButton.isUserInteractionEnabled = true
    }
}

//MARK: Response Delegate
extension MessageLobbyViewController: MessageLobbyResponseDelegate {
    func onReceivingUserNum(num: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view.isUserInteractionEnabled = true
            self.connectedUserNumberLabel.text = String(num)
            self.activityIndicatorView?.removeFromSuperview()
            self.activityIndicatorView = nil
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
            self.connectionButton.isEnabled = false
            self.connectionButton.alpha = 0.6
            
            //display the chat room
            ViewControllerRouter.presentMessageChatRoomViewController(currentVC: self, withDelay: 1)
            
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
    func onCancelBtnClicked() {
        //Nothing
    }
    
    func onConfirmBtnClicked(userName: String) {
        logger.info("User name change confirm button clicked")
        self.userNameView?.removeFromSuperview()
        self.userNameView = nil
        self.connectionButton.isUserInteractionEnabled = true
        
        SocketConnectionManager.sharedInstance.userName = userName
        
        //Request for updating user name
        MessagingRequestAPIs.sharedInstance.requestForChangeUserName(name: SocketConnectionManager.sharedInstance.userName)
        
        DispatchQueue.main.async {
            self.currentNameLabel.text = Constants.MessageLobbyUIWording.CurrentName(name: SocketConnectionManager.sharedInstance.userName)
        }
    }
    
}

extension MessageLobbyViewController: LobbyAlertMenuViewModelDelegate {
    
    func onChangeNameActionClicked() {
        print("change name")
        
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
        userNameView.layer.cornerRadius = 10
        self.userNameView = userNameView
        self.userNameView?.delegate = self
        
        let layerBound = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 200)
        self.userNameView?.setupGradientColorAndShadow(bound: layerBound)
        
        self.userNameView?.addBlurView()
    }
    
    func onBlockActionClicked() {
        print("block")
        
        let userHistoryView = UserHistoryView(frame: CGRect.zero)
        
        self.view.addSubview(userHistoryView)
        
        userHistoryView.translatesAutoresizingMaskIntoConstraints = false
        userHistoryView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userHistoryView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        userHistoryView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        userHistoryView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        
        userHistoryView.delegate = self
        userHistoryView.purpose = .Block
        userHistoryView.addBlurView()
    }
    
    func onReportActionClicked() {
        print("report")
        let userHistoryView = UserHistoryView(frame: CGRect.zero)
        
        self.view.addSubview(userHistoryView)
        
        userHistoryView.translatesAutoresizingMaskIntoConstraints = false
        userHistoryView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userHistoryView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        userHistoryView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        userHistoryView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        
        userHistoryView.delegate = self
        userHistoryView.purpose = .Report
        userHistoryView.addBlurView()
    }
    
    func onDevContactActionClicked() {
        print("devcontact")
        //Display ContactInfo View
        let contactInfoView = CustomMessageView(frame: CGRect.zero)
        contactInfoView.setCustomMessageLabel(message: Constants.contactInfoMessage)
        
        self.view.addSubview(contactInfoView)
        
        contactInfoView.translatesAutoresizingMaskIntoConstraints = false
        contactInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contactInfoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        contactInfoView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        contactInfoView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        
        contactInfoView.addBlurView()
    }
    
    func onEULAActionClicked() {
        print("EULA")
        //Display EULA View
        let eulaView = EULAView(frame: CGRect.zero)
        eulaView.loadEULA(viewOnly: true)
        self.view.addSubview(eulaView)
        
        eulaView.translatesAutoresizingMaskIntoConstraints = false
        eulaView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eulaView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        eulaView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        eulaView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
        
        eulaView.addBlurView()
    }
    
}

extension MessageLobbyViewController: UserHistoryViewDelegate {
    
    func onSelectedCellRow(userId: String, userName: String, purpose: UserHistoryView.UserHistoryViewPurpose) {
        
        switch purpose {
            
        case .Block:
            //Display the block alert view
            let alertController = UIAlertController(title: "Block", message: "You will block the selected user and you won't be matched with this user", preferredStyle: UIAlertControllerStyle.alert)
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertActionStyle.default, handler: { action in
                
                //Send the report
                MessagingRequestAPIs.sharedInstance.requestForBlockUser(blockedUserId: userId)
                logger.info("Block Request was sent")
                
                //Display popup
                let label = PopUpMessageLabel(message: "Selected user has been blocked")
                self.view.addSubview(label)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                    label.removeFromSuperview()
                })
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(blockAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            break
        case .Report:
            //Display the report alert view
            let alertController = UIAlertController(title: "Report", message: "You will report the selected user for abusement", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addTextField(configurationHandler: { textField in
                textField.placeholder = "Please add details"
            })
            
            let reportAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: { action in
                
                guard let message = alertController.textFields?.first?.text else {
                    return
                }
                
                //Send the report
                MessagingRequestAPIs.sharedInstance.requestForReportUser(reportedUserId: userId, reportedUserName: userName, details: message)
                logger.info("Report Request was sent")
                
                //Display popup
                let label = PopUpMessageLabel(message: "Report has been sent")
                self.view.addSubview(label)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                    label.removeFromSuperview()
                })
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(reportAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        }
        
    }
    
}
