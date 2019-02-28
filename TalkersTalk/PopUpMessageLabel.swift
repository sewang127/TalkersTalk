//
//  PopUpMessageLabel.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/12/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit

class PopUpMessageLabel: UILabel {
    
    convenience init(message: String) {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let width: CGFloat = 200.0
        let height: CGFloat = 150.0
        
        let rect = CGRect(x: screenWidth/2 - width/2, y: screenHeight/2 - height/2, width: width, height: height)
        self.init(frame: rect)
        
        self.text = message
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(displayP3Red: 89.0/255.0, green: 174.0/255.0, blue: 209.0/255.0, alpha: 1)
        self.clipsToBounds = true
        self.numberOfLines = 0
        self.textAlignment = .center
    }
    
}
