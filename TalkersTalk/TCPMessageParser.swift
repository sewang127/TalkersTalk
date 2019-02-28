//
//  TCPMessageParser.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/28/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation
import SwiftyJSON

class TCPMessageParser {
    
    class func encodeMessageJson(message: String, purpose: Constants.TCPMessagePurpose, args: [String: String]? = nil) -> Data? {
        
        var jsonDict: JSON?
        
        switch purpose {
        case .ChatMessage:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue,
                "message": message
            ]
            
            break
        case .UserNum:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue
            ]
            
            break
            
        case .ConnectChatRoom:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue
            ]
            break
            
        case .CancelChatRoomConnection:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue
            ]
            break
            
        case .LeaveChatRoom:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue
            ]
            break
            
        case .Verification:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue,
                "code": message
            ]
            break
            
        case .ChangeUserName:
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue,
                "name": SocketConnectionManager.sharedInstance.userName
            ]
            break
            
        case .ServerHasNoRoom:
            //This is not used as request
            break
            
        case .ReportUser:
            let userNameReported = args!["user"]!
            let userIdReported = args!["id"]!
            let details = args!["details"]!
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue,
                "reporter": SocketConnectionManager.sharedInstance.userName,
                "id": userIdReported,
                "user": userNameReported,
                "details": details
            ]
            break
        
        case .BlockUser:
            let blockedUserId = args!["user"]!
            jsonDict = [
                "type": Constants.TCPMessageType.Request.rawValue,
                "purpose": purpose.rawValue,
                "user": blockedUserId
            ]
            break
            
        }
        
        if let jsonDict = jsonDict {
            if let jsonRawData = try? jsonDict.rawData() {
                var formattedData = "<--".data(using: .utf8)!
                formattedData.append(jsonRawData)
                formattedData.append("-->".data(using: .utf8)!)
                return formattedData
            }
        }
        
        return nil
    }
    
    class func getValidMessageData(data: Data) -> [String] {
        //Currently doesn't reflect the unprocessesd data.
        
        guard var dataStr = String(data: data, encoding: String.Encoding.utf8) else {
            logger.error("String couldn't be extracted from data")
            return []
        }
        
        var validMessageStrArray: [String] = []
        
        while dataStr != "" {
            
            guard let firstStartIndex = dataStr.range(of: "<--")?.upperBound else {
                logger.error("No more starting indicator wasn't found")
                return validMessageStrArray
            }
            
            guard let firstEndIndex = dataStr.range(of: "-->", options: [], range: Range<String.Index>(uncheckedBounds: (firstStartIndex, dataStr.endIndex)), locale: nil)?.lowerBound else {
                logger.error("Valid Ending indicator wasn't found")
                return validMessageStrArray
            }
            
            let validMessageStr = String(dataStr[firstStartIndex..<firstEndIndex])
            
            validMessageStrArray.append(validMessageStr)
            
            dataStr = String(dataStr[firstEndIndex...])
        }
        
        return validMessageStrArray
    }
    
    class func parseTCPMessageJson(jsonStr: String) {
        let json = JSON(parseJSON: jsonStr)
        let messageType = json["type"].stringValue
        let purpose = json["purpose"].stringValue
        
        logger.info("Parsed message Info - Type: \(messageType), purpose: \(purpose)")
        
        switch messageType {
        case Constants.TCPMessageType.Request.rawValue:
            logger.info("Request type should not be received on client")
            break
        case Constants.TCPMessageType.Response.rawValue:
            
            //Check purpose
            switch purpose {
            case Constants.TCPMessagePurpose.ChatMessage.rawValue:
                //Process received message
                let sender = json["sender"].stringValue
                let message = json["message"].stringValue
                let logid = json["logid"].stringValue
                
                MessagingResponseAPIs.sharedInstance.receivedTextMessage(logid: logid, sender: sender, message: message)
                
                
                /*
                //Post the message received notification
                MesssageNotificationCenterManager.sharedInstance.postMessageReceived(logid: logid, sender: sender, message: message)
                */
                break
            case Constants.TCPMessagePurpose.UserNum.rawValue:
                //Process received user number
                let number = json["number"].intValue
                MessagingResponseAPIs.sharedInstance.receivedUserNum(num: number)
                break
            case Constants.TCPMessagePurpose.ConnectChatRoom.rawValue:
                let status = json["status"].stringValue
                let failureReasonCode = json["reason"].intValue
                let strangerName = json["userName"].stringValue
                let strangerId = json["userId"].stringValue
                
                if status == Constants.MessagingResponseStatus.Failure.rawValue {
                    //Failure
                    
                    if failureReasonCode == 1 {
                        //No matching found
                        MessagingResponseAPIs.sharedInstance.receivedJoinChatRoomStatus(strangerId: nil, strangerName: nil, status: .Failure, error: .NoMatchFound)
                    } else {
                        //Temporary error handling
                        MessagingResponseAPIs.sharedInstance.receivedJoinChatRoomStatus(strangerId: nil, strangerName: nil, status: .Failure, error: .Timeout)
                    }
                    
                } else {
                    //Success
                    MessagingResponseAPIs.sharedInstance.receivedJoinChatRoomStatus(strangerId: strangerId, strangerName: strangerName, status: .Success, error: nil)
                }
                
                break
                
            case Constants.TCPMessagePurpose.CancelChatRoomConnection.rawValue:
                MessagingResponseAPIs.sharedInstance.receivedCancelingChatRoomConnection()
                
            case Constants.TCPMessagePurpose.LeaveChatRoom.rawValue:
                let status = json["status"].stringValue
                let didMySelfLeave = json["didMySelfLeave"].boolValue
                
                if status == Constants.MessagingResponseStatus.Success.rawValue {
                    //Success
                    MessagingResponseAPIs.sharedInstance.receivedLeaveChatRoomStatus(status: .Success, didMySelfLeave: didMySelfLeave)
                } else {
                    //Failure
                    MessagingResponseAPIs.sharedInstance.receivedLeaveChatRoomStatus(status: .Failure, didMySelfLeave: didMySelfLeave)
                }
                
                break
            
            case Constants.TCPMessagePurpose.Verification.rawValue:
                let status = json["status"].stringValue
                let userId = json["id"].stringValue
                
                if status == Constants.MessagingVerificationStatus.Required.rawValue {
                    MessagingResponseAPIs.sharedInstance.receivedVerificationRequest(userId: userId)
                } else if status == Constants.MessagingVerificationStatus.Completed.rawValue {
                    MessagingResponseAPIs.sharedInstance.receivedVerificationCompleted()
                }
                break
                
            case Constants.TCPMessagePurpose.ServerHasNoRoom.rawValue:
                MessagingResponseAPIs.sharedInstance.receivedServerHasNoRoom()
                break
                
            default:
                logger.error("This should not be called!!!")
                assert(true)
            }
            
            break
        default:
            logger.error("This should not be called!!!")
            assert(true)
        }
        
    }

}
