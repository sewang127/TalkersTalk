//
//  SocketConnectionManager.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/18/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

//Currently contain all the information related to message lobby, chat room
class SocketConnectionManager {
    
    static let sharedInstance = SocketConnectionManager()
    private init() {}
    
    var userId = ""
    var userName = ""
    var strangerName = ""
    
    var strangerIdHistory: [(userId: String, userName: String)] = [] {
        
        didSet {
            
            //Only Keep upto 10 ids
            if strangerIdHistory.count > 10 {
                strangerIdHistory.removeFirst()
                print("Id removed!")
            }
        }
    }
    
}
