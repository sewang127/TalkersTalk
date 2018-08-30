//
//  MessageRoomViewController.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/28/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class MessageRoomViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leavePopUpLabel: UILabel!
    @IBOutlet weak var customMessageTextView: CustomMessageTextView!
    
    var viewModel: MessageRoomViewPresentable?
    var indexPathOfLastCell: IndexPath?
    var isKeyboardShown: Bool = false
    
    deinit {
        print("The message Room vc is being deallocated")
        NotificationCenter.default.removeObserver(self) //This is not needed in iOS 9 or higher
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupKeyboardNotification()
        
        MessagingResponseAPIs.sharedInstance.chatRoomDelegate = self
       
        self.topView.layoutIfNeeded()
        let topColor = UIColor.white
        let bottomColor = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        let gradientLayer = GradientColorMaker.createGradientColorLayer(topColor: topColor, bottomColor: bottomColor, bound: self.topView.bounds)
        
        self.topView.layer.shadowColor = UIColor.black.cgColor
        self.topView.layer.shadowOpacity = 0.8
        self.topView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        self.topView.layer.insertSublayer(gradientLayer, at: 0)
        self.topView.backgroundColor = UIColor.clear
        
        //Set tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerTapped(sender:)))
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
        
        let tableViewImageView = UIImageView(frame: self.tableView.bounds)
        tableViewImageView.image = UIImage(named: "SplashScreenBackground1")
        self.tableView.backgroundView = tableViewImageView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.customMessageTextView.delegate = self
        //setting dynamically sized cell
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib(nibName: Constants.TableViewCellIdentifiers.MessageRoomIncomingTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifiers.MessageRoomIncomingTableViewCell.rawValue)
        self.tableView.register(UINib(nibName: Constants.TableViewCellIdentifiers.MessageRoomOutgoingTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifiers.MessageRoomOutgoingTableViewCell.rawValue)
        self.tableView.register(UINib(nibName: Constants.TableViewCellIdentifiers.MessageRoomNotificationTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifiers.MessageRoomNotificationTableViewCell.rawValue)

        //setup viewModel
        self.viewModel = MessageRoomViewModel(withInitailNotificationMessages: true)
        self.viewModel?.newItemAddedBlock = { [weak self] in
            logger.info("ViewController is getting reloaded as a new item was introduced")
            self?.tableView.reloadData()
            
            //Whenever tableview is reloaded, go to the bottom of the tableView
            DispatchQueue.main.async {
                if let indexPath = self?.indexPathOfLastCell {
                    self?.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
                }
            }
        }
        
        //Add notification messages that show who entered the chat
        
        
        
        //MessagingResponseAPIs.sharedInstance.addListener(listener: self)
        
        /*
        //make an observer for Message notification
        MesssageNotificationCenterManager.sharedInstance.subscribeToMessageReceived(block: { logid, sender, message in
            
            logger.info("ViewController Block is getting exectuted - logid: \(logid), sender: \(sender), message: \(message)")
            
            //form view model
            self.viewModel?.addItem(logid: logid, sender: sender, message: message)
        })
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disappear and unsubscribe the api listeners")
        MessagingResponseAPIs.sharedInstance.chatRoomDelegate = nil
        //MessagingResponseAPIs.sharedInstance.removeListener(listener: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLeaveBtnClicked(_ sender: Any) {
        logger.info("Leave chat room btn was clicked")
        MessagingRequestAPIs.sharedInstance.requestForLeavingChatRoom()
        
    }
    
    //Keyboard notification
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil);
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if isKeyboardShown == true {
            //return here since keyboard was already shown
            return
        }
        isKeyboardShown = true
        
        guard let userInfo = notification.userInfo else {
            return
        }
        //self.scrollTableViewToBottom(animated: true)
        //let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.2
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero).size.height
        
        self.tableView.contentOffset.y += keyboardHeight
        self.view.frame.size.height -= keyboardHeight
        self.view.layoutIfNeeded()
        print("key show!!")
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("Key hide!!")
        isKeyboardShown = false
        guard let userInfo = notification.userInfo else {
            return
        }
        
        //let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.2
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero).size.height
        
        self.tableView.contentOffset.y -= keyboardHeight
        if self.tableView.contentOffset.y < 0 {
            //Avoid malfunctioning of tableView when the contentOffset is smaller than the size of the tableview
            self.tableView.contentOffset.y = 0
        }
        self.view.frame.size.height += keyboardHeight
        self.view.layoutIfNeeded()
        
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer) {
        //If tableView is tapped while the keyboard is shown, hide it by resign first responder
        self.customMessageTextView.messageTextView.resignFirstResponder()
    }
    
}

//MARK: CustomTextFieldViewDelegate
extension MessageRoomViewController: CustomMessageTextViewDelegate {
    
    func onSendBtnClicked(message: String) {
        
        MessagingRequestAPIs.sharedInstance.requestForSendingChatMessage(message: message)
        
        //update vm as well
        self.viewModel?.addItem(logid: "", sender: "", message: message, direction: Constants.MessageViewModelDirection.Out)
    }
    
}

//MARK: TableView Delegate/DataSource

extension MessageRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        let index = indexPath.row
        
        if indexPath.row == self.viewModel!.items.count - 1 {
            self.indexPathOfLastCell = indexPath
        }
        
        let item = self.viewModel!.items[index]
        
        //Creating Notification Message
        if item.isNotificationMessage {
            cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.MessageRoomNotificationTableViewCell.rawValue, for: indexPath)
            if let cell = cell as? MessageRoomNotificationTableViewCell {
                let notificationMessage = item.message
                cell.setNotificationLabel(label: notificationMessage)
            }
            
            cell.backgroundColor = nil
            return cell
        }
        
        var date: Date?
        
        if index == 0 {
            date = item.date //If Index is 0, display date
        } else {
            
            //If index is 1 or more, compare with previous message date and display date only if there is a minute or more difference
            let previousMessageDate = self.viewModel!.items[index-1].date
            let currentMessageDate = item.date
            
            //Make sure the previous message is not notification message
            if self.viewModel!.items[index-1].isNotificationMessage == true {
                date = currentMessageDate
            } else {
                if previousMessageDate.timeIntervalSince1970 < currentMessageDate.timeIntervalSince1970 {
                    //Check if it's at least a minute late
                    let calendar = Calendar.current
                    let originalMinute = calendar.component(Calendar.Component.minute, from: previousMessageDate)
                    let newMinute = calendar.component(Calendar.Component.minute, from: currentMessageDate)
                    
                    if originalMinute != newMinute {
                        date = currentMessageDate
                    }
                }
            }
        }
        
        let message = item.message
        let direction = item.direction
        
        if direction == .In {
            cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.MessageRoomIncomingTableViewCell.rawValue, for: indexPath)
            let incomingCell = cell as! MessageRoomIncomingTableViewCell
            let strangerName = SocketConnectionManager.sharedInstance.strangerName
            incomingCell.setMessageLabel(message: message, name: strangerName, date: date)
        } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.MessageRoomOutgoingTableViewCell.rawValue, for: indexPath)
            let outgoingCell = cell as! MessageRoomOutgoingTableViewCell
            outgoingCell.setMessageLabel(message: message, date: date)
        }
        
        cell.backgroundColor = nil
        return cell
    }
    
}

//Messaging response api delegates
extension MessageRoomViewController: MessageChatRoomResponseDelegate {
    
    func onLeavingChatRoomStatus(status: Constants.MessagingResponseStatus, didMySelfLeave: Bool) {
        
        //No matter if the status is successful or not, leave the chat
        leavePopUpLabel.isHidden = false
        
        if didMySelfLeave == true {
            leavePopUpLabel.text = "You have left the room"
        } else {
            leavePopUpLabel.text = "The stranger left the room"
        }
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func onReceivingTextMessage(logid: String, sender: String, message: String) {
        //form view model
        self.viewModel?.addItem(logid: logid, sender: sender, message: message, direction: Constants.MessageViewModelDirection.In)
    }
    
}
