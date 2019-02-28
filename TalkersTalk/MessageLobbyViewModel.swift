//
//  MessageLobbyViewModel.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/2/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import Foundation

protocol MessageLobbyViewPresentable {
    
    var totalUserNum: Int { get set }
    
}

class MessageLobbyViewModel: MessageLobbyViewPresentable {
    
    var totalUserNum: Int = 0
    
}
