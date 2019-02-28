//
//  MessagingRequestAPIs.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/2/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation

class MessagingRequestAPIs {
    
    static let sharedInstance = MessagingRequestAPIs()
    private init() {}
    
    func requestForGettingUserNum() {
        //Send a request to server to get the total connected user number
        logger.info("Request API - getting user number")
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .UserNum) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
        
    }
    
    func requestForSendingChatMessage(message: String) {
        logger.info("Request API - sending chat message")
        guard let data = TCPMessageParser.encodeMessageJson(message: message, purpose: .ChatMessage) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForConnectingChatRoom() {
        //Send a request that the client wants to connect to a chat room with a random person
        logger.info("Request API - connecting to chat room")
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .ConnectChatRoom) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForCancelingConnectionChatRoom() {
        //Send a request that the client wants to ongoing request for chat room connection
        logger.info("Request API - canceling the chat room connection")
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .CancelChatRoomConnection) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForLeavingChatRoom() {
        logger.info("Request API - leaving chat room")
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .LeaveChatRoom) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForChangeUserName(name: String) {
        logger.info("Request API - Change User Name")
        SocketConnectionManager.sharedInstance.userName = name
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .ChangeUserName) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForReportUser(reportedUserId: String, reportedUserName: String, details: String) {
        logger.info("Request API - Report User")
        
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .ReportUser, args: ["id": reportedUserId, "user": reportedUserName, "details": details]) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
    
    func requestForBlockUser(blockedUserId: String) {
        logger.info("Request API - Block User")
        
        guard let data = TCPMessageParser.encodeMessageJson(message: "", purpose: .BlockUser, args: ["user": blockedUserId]) else {
            logger.error("The request message couldn't be encoded into json")
            return
        }
        
        TCPConnectionService.sharedInstance.streamMessageData(messageData: data)
    }
}
