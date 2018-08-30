//
//  MessagingResponseAPIs.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/2/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation

/*
protocol MessagingResponseDelegate: class {
    
    func onReceivingUserNum(num: Int)
    func onJoiningChatRoomStatus(status: Constants.MessagingResponseStatus, error: Constants.MessagingJoiningChatRoomResponseError?)
    func onLeavingChatRoomStatus(status: Constants.MessagingResponseStatus, didMySelfLeave: Bool)
    func onCancelingChatRoomConnection()
    
    func onReceivingTextMessage(logid: String, sender: String, message: String)
    func onReceivingVerificationCompleted()
}
*/

protocol ServerConnectionDelegate: class {
    func onConnectedToServer()
}

protocol MessageLobbyResponseDelegate: class {
    func onReceivingUserNum(num: Int)
    func onJoiningChatRoomStatus(status: Constants.MessagingResponseStatus, error: Constants.MessagingJoiningChatRoomResponseError?)
    func onCancelingChatRoomConnection()
}

protocol MessageChatRoomResponseDelegate: class {
    func onLeavingChatRoomStatus(status: Constants.MessagingResponseStatus, didMySelfLeave: Bool)
    func onReceivingTextMessage(logid: String, sender: String, message: String)
}

class MessagingResponseAPIs: TCPConnectionServiceDelegate {
    
    static let sharedInstance = MessagingResponseAPIs()
    private init() {}
    
    //var listeners: [MessagingResponseDelegate] = []
    
    var lobbyDelegate: MessageLobbyResponseDelegate?
    var chatRoomDelegate: MessageChatRoomResponseDelegate?
    var serverConnectionDelegate: ServerConnectionDelegate?
    
    /*
    func addListener(listener: MessagingResponseDelegate) {
        if listeners.contains(where: {$0 === listener}) {
            logger.info("Current listener was already added before")
            return
        }
        listeners.append(listener)
        logger.info("Added the listener to the array")
    }
    
    func removeListener(listener: MessagingResponseDelegate) {
        for (index, val) in self.listeners.enumerated().reversed() {
            if val === listener {
                self.listeners.remove(at: index)
                logger.info("Removed the listener from the array")
            }
        }
    }
    */
    
    func receivedVerificationRequest(userId: String) {
        logger.info("Received Verification Request from server")
        //Will send request right away to handle handshake
        SocketConnectionManager.sharedInstance.userId = userId
        TCPConnectionService.sharedInstance.sendVerificationData()
    }
    
    func receivedVerificationCompleted() {
        logger.info("Received Verification Completed from server")
        self.serverConnectionDelegate?.onConnectedToServer()
    }
    
    
    func receivedUserNum(num: Int) {
        logger.info("Received the total connected user: \(num)")
        self.lobbyDelegate?.onReceivingUserNum(num: num)
    }
    
    func receivedJoinChatRoomStatus(status: Constants.MessagingResponseStatus, error: Constants.MessagingJoiningChatRoomResponseError?) {
        logger.info("Received join chat room response - status: \(status)")
        self.lobbyDelegate?.onJoiningChatRoomStatus(status: status, error: error)
    }
    
    func receivedLeaveChatRoomStatus(status: Constants.MessagingResponseStatus, didMySelfLeave: Bool) {
        logger.info("Received leave chat room response - status: \(status), didMySelfLeave: \(didMySelfLeave)")
        self.chatRoomDelegate?.onLeavingChatRoomStatus(status: status, didMySelfLeave: didMySelfLeave)
    }
    
    func receivedTextMessage(logid: String, sender: String, message: String) {
        logger.info("Received text message response - message: \(message)")
        self.chatRoomDelegate?.onReceivingTextMessage(logid: logid, sender: sender, message: message)
    }
    
    func receivedCancelingChatRoomConnection() {
        logger.info("Received canceling chat room connection response")
        self.lobbyDelegate?.onCancelingChatRoomConnection()
    }
    
    func receivedServerHasNoRoom() {
        logger.info("Received server has no room response")
        ViewControllerRouter.displayAlertController(title: "Connection Rejected", message: "Too many people are using the app. Please retry later.", blockToExecute: { _ in })
    }
    
}
