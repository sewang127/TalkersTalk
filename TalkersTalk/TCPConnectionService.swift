//
//  TCPConnectionService.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/25/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol TCPConnectionServiceDelegate {
    
    func receivedUserNum(num: Int)
    
}

//Singleton tcp connection service class
class TCPConnectionService: NSObject {
    
    static let sharedInstance = TCPConnectionService()
    private override init() {super.init()}
    
    var connectionState: Constants.TCPConnectionState = .NotConnected
    
    fileprivate var inputStream: InputStream?
    fileprivate var outputStream: OutputStream?
    //fileprivate var inputStringBuffer: String = ""//Keep the unprocessed data string
    
    func setupIOStream() {
        
        let endPoint = Constants.TCPServiceConstants.ServerEndPoint
        let port = UInt32(Constants.TCPServiceConstants.Port.rawValue)!
        
        let host = endPoint.rawValue as NSString
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readStream, &writeStream)
        
        self.inputStream = readStream?.takeRetainedValue()
        self.outputStream = writeStream?.takeRetainedValue()
        
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        self.inputStream?.schedule(in: .current, forMode: .defaultRunLoopMode)
        self.outputStream?.schedule(in: .current, forMode: .defaultRunLoopMode)
        
        self.inputStream?.open()
        self.outputStream?.open()
        
    }
    
    func closeTCPConnection() {
        self.inputStream?.close()
        self.outputStream?.close()
        logger.info("Closed TCP connection with server")
    }
    
    
    func establishTCPConnection() {
        
        switch self.connectionState {
        case .Connected:
            logger.info("Establishing TCP connection is not needed. It's already connected")
            break
        case .Connecting:
            logger.info("TCP is in connecting state... Please wait until the process is finished")
            break
        case .NotConnected:
            logger.info("Establishing TCP connection with server...")
            self.connectionState = .Connecting
            self.setupIOStream()
            break
        }
    }
    
    func streamMessageData(messageData: Data) {
        guard let outputStream = self.outputStream else {
            print("Output stream is nil")
            return
        }
        
        messageData.withUnsafeBytes{ (content: UnsafePointer<UInt8>) -> () in
            let byteSent = outputStream.write(content, maxLength: messageData.count)
            print("Message was sent: \(messageData) - byteSent: \(byteSent)")
        }
    }
    
    func sendVerificationData() {
        let userId = SocketConnectionManager.sharedInstance.userId
        if let code = "\(userId)\(Constants.VerificationCode.first.rawValue)".data(using: .utf8)?.sha224() {
            guard let data = TCPMessageParser.encodeMessageJson(message: code.toHexString(), purpose: .Verification) else {
                logger.error("The request message couldn't be encoded into json")
                return
            }
            
            self.streamMessageData(messageData: data)
        }
        
    }
    
}

extension TCPConnectionService: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        logger.debug("Stream type: \(aStream), event type: \(eventCode)")
        
        switch eventCode {
        case Stream.Event.openCompleted:
            logger.info("Connection completed")
            self.connectionState = .Connected
            break
        case Stream.Event.hasBytesAvailable:
            print("hasBytesAvailable")
            if let inputStream = self.inputStream, aStream == inputStream {
                let inputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4096)
                let byteRead = inputStream.read(inputBuffer, maxLength: 4096)
                var readData = Data()
                readData.append(inputBuffer, count: byteRead)
                print("Data received: \(String(data: readData, encoding: .utf8))")
                
                let validStrArr = TCPMessageParser.getValidMessageData(data: readData)
                
                validStrArr.forEach({ TCPMessageParser.parseTCPMessageJson(jsonStr: $0) })
                
            }
            break
        case Stream.Event.hasSpaceAvailable:
            print("hasSpaceAvailable")
            break
        case Stream.Event.errorOccurred:
            logger.info("Error occurred")
            
            ViewControllerRouter.displayAlertController(title: "Connection Failed", message: "Server connection failed", blockToExecute: { currentVC in
                ViewControllerRouter.moveToSplashScreen(currentVC: currentVC)
            })
            
            self.inputStream?.close()
            self.outputStream?.close()
            self.connectionState = .NotConnected
            
            break
        case Stream.Event.endEncountered:
            logger.info("endEncountered - socket connection closed")
            
            ViewControllerRouter.displayAlertController(title: "Connection Lost", message: "Server connection was lost", blockToExecute: { currentVC in
                ViewControllerRouter.moveToSplashScreen(currentVC: currentVC)
            })
            
            self.inputStream?.close()
            self.outputStream?.close()
            self.connectionState = .NotConnected
            
            break
        default:
            logger.error("UnExpected response found!!! - This should not be called!!!")
            
        }
        
    }
    
}
