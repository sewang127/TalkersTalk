//
//  MessageViewModel.swift
//  RandomChat
//
//  Created by Se Wang Oh on 7/28/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation

protocol MessageRoomViewPresentable {
    
    var items: [MessageItemViewPresentable] { get set }
    
    var newItemAddedBlock: (()->())? { get set }
    
    func addItem(item: MessageItemViewPresentable)
    func addItem(logid: String, sender: String, message: String, direction: Constants.MessageViewModelDirection)
}

protocol MessageItemViewPresentable {
    
    var direction: Constants.MessageViewModelDirection { get set }
    var sender: String { get set }
    var message: String { get set }
    var date: Date { get set }
    
}

class MessageRoomViewModel: MessageRoomViewPresentable {
    
    var items: [MessageItemViewPresentable] = []
    
    var newItemAddedBlock: (()->())? = nil
    
    init(items: [MessageItemViewPresentable]) {
        self.items = items
    }
    
    func addItem(item: MessageItemViewPresentable) {
        self.items.append(item)
        self.newItemAddedBlock?()
    }
    
    func addItem(logid: String, sender: String, message: String, direction: Constants.MessageViewModelDirection) {
        let direction = direction
        let itemVM = MessageItemViewModel(direction: direction, sender: sender, message: message)
        self.addItem(item: itemVM)
    }
    
    /*
    func updateLastTimeShown(date: Date) -> Bool {
        if self.lastTimeShown == nil {
            self.lastTimeShown = date
            return true
        }
        
        if self.lastTimeShown!.timeIntervalSince1970 < date.timeIntervalSince1970 {
            //Check if it's at least a minute late
            let calendar = Calendar.current
            let originalMinute = calendar.component(Calendar.Component.minute, from: self.lastTimeShown!)
            let newMinute = calendar.component(Calendar.Component.minute, from: date)
            
            if originalMinute != newMinute {
                self.lastTimeShown = date
                return true
            }
            
            return false
        }
        
        return false
    }
    */
}

class MessageItemViewModel: MessageItemViewPresentable {
    
    var direction: Constants.MessageViewModelDirection
    var sender: String
    var message: String
    var date: Date
    
    init(direction: Constants.MessageViewModelDirection, sender: String, message: String) {
        self.direction = direction
        self.sender = sender
        self.message = message
        self.date = Date()
    }
}


