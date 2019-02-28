//
//  MessageNotificationService.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/28/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation

//Currently not used
class MesssageNotificationCenterManager {
    
    static let sharedInstance = MesssageNotificationCenterManager()
    private init() {}
    
    var messageReceivedBlocks: [(String, String, String)->()] = []
    
    func postMessageReceived(logid: String, sender: String, message: String) {
        NotificationCenter.default.post(name: NSNotification.Name.TCPMessageReceived, object: nil, userInfo: ["logid" : logid, "sender": sender, "message": message])
    }
    
    func subscribeToMessageReceived(block: @escaping (String, String, String)->()) {
        
        messageReceivedBlocks.append(block)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedMessageReceivedNotification), name: NSNotification.Name.TCPMessageReceived, object: nil)
    }
    
    @objc func receivedMessageReceivedNotification(notification: Notification) {
        let logid = notification.userInfo!["logid"] as! String
        let sender = notification.userInfo!["sender"] as! String
        let message = notification.userInfo!["message"] as! String
        
        self.messageReceivedBlocks.forEach { (block) in
            block(logid, sender, message)
        }
    }
    
    //TODO: This currently removes all the observers assigned in this class. Need an approach like RxSwift to remove only a specific observer
    func unsubscribeMessageReceived() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.TCPMessageReceived, object: nil)
    }

}
