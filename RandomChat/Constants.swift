//
//  Constants.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/25/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

//List of enum/constant variables

struct Constants {
    
    static let messageSizeLimitInByte = 1000
    
    enum VerificationCode: String {
        case first = "sworandomchat"
    }
    
    enum TCPConnectionState: String {
        case Connected = "Connected"
        case Connecting = "Connecting"
        case NotConnected = "NotConnected"
    }
    
    enum TCPServiceConstants: String {
        //case ServerEndPoint = "127.0.0.1"
        case ServerEndPoint = "132.148.132.204"
        case Port = "1060"
    }
    
    enum TCPMessageType: String {
        case Request = "Request"
        case Response = "Response"
    }
    
    enum TCPMessagePurpose: String {
        case ChatMessage = "ChatMessage"
        case UserNum = "UserNum"
        case ConnectChatRoom = "ConnectChatRoom"
        case CancelChatRoomConnection = "CancelChatRoomConnection"
        case LeaveChatRoom = "LeaveChatRoom"
        case Verification = "Verification"
        case ChangeUserName = "ChangeUserName"
        case ServerHasNoRoom = "ServerHasNoRoom"
    }
    
    enum MessageViewModelDirection: String {
        case In = "In"
        case Out = "Out"
    }
    
    enum TableViewCellIdentifiers: String {
        case MessageRoomIncomingTableViewCell = "MessageRoomIncomingTableViewCell"
        case MessageRoomOutgoingTableViewCell = "MessageRoomOutgoingTableViewCell"
        case MessageRoomNotificationTableViewCell = "MessageRoomNotificationTableViewCell"
    }
    
    
    //For UI Labeling
    enum MessageLobbyViewLabels: String {
        case ConnectionButtonMatch = "Join Chat"
        case ConnectionButtonCancel = "Cancel"
        case ConnectionLabelMatching = "Matching with other user..."
        case ConnectionLabelWaiting = "Waiting for other user"
        case ConnectionLabelMatchFound = "Found a match!"
        case ConnectionLabelRetry = "No match found. Please retry later"
    }
    
    
    struct MessageChatRoomUIWording {
        static func HasEnteredNotificationMessage(name: String) -> String { return "\"\(name)\" has entered the chat room"}
    }
    
    struct MessageLobbyUIWording {
        static func CurrentName(name: String) -> String {
            return "Current Name: \(name)"
        }
    }
    
    
    //For Messaging response apis
    enum MessagingResponseStatus: String {
        case Success = "Success"
        case Failure = "Failure"
    }
    
    enum MessagingVerificationStatus: String {
        case Required = "Required"
        case Completed = "Completed"
    }
    
    enum MessagingJoiningChatRoomResponseError: String {
        case Timeout = "Timeout"
        case NoMatchFound = "NoMatchFound"
    }

}


