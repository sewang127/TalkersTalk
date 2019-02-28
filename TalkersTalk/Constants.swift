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
    
    static let objectionableContentWordList: [String] = ["asshole", "assholes", "asskisser", "asswipe", "biatch", "bitch", "bitches", "bitchin", "bitching", "blowjob", "blowjobs", "boner", "boob", "boobies", "boobs", "bullshit", "bunghole", "buttfuck", "buttfucker", "butthole", "buttplug", "circlejerk", "cocksuck", "cocksucker", "cocksucking", "cumshot", "cunt", "cuntlick", "cuntlicker", "cuntlicking", "cunts", "dipshit", "douchebag", "dumbass", "fag", "fagget", "faggit", "faggot", "faggs", "fagot", "fagots", "fags", "fatass", "fingerfuck", "fingerfucked", "fingerfucker", "fingerfuckers", "fingerfucking", "fingerfucks", "fistfuck", "fistfucked", "fistfucker", "fistfuckers", "fistfucking", "fistfuckings", "fistfucks", "fuck", "fucked", "fucker", "fuckers", "fuckin", "fucking", "fuckings", "fuckme", "fucks", "goddamn", "hardcoresex", "hotsex", "jackingoff", "jackoff", "jack-off", "jerk-off", "jism", "jiz", "jizm", "jizz", "mothafuck", "mothafucka", "mothafuckas", "mothafuckaz", "mothafucked", "mothafucker", "mothafuckers", "mothafuckin", "mothafucking", "mothafuckings", "mothafucks", "motherfuck", "motherfucked", "motherfucker", "motherfuckers", "motherfuckin", "motherfucking", "motherfuckings", "motherfucks", "nigga", "nigger", "niggers", "phonesex", "shit", "shited", "shitfull", "shiting", "shits", "shitted", "shitter", "shitters", "shitting", "shitty", "slut", "sluts", "twat"]
    
    static let contactInfoMessage = "You can contact us via\nTwitter: https://twitter.com/talk_talkers\nEmail: sewang127@gmail.com"
    
    enum VerificationCode: String {
        case first = "Your verification code"
    }
    
    enum TCPConnectionState: String {
        case Connected = "Connected"
        case Connecting = "Connecting"
        case NotConnected = "NotConnected"
    }
    
    enum TCPServiceConstants: String {
        case ServerEndPoint = "127.0.0.1"
        //case ServerEndPoint = "Your server domain"
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
        case ReportUser = "ReportUser"
        case BlockUser = "BlockUser"
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


