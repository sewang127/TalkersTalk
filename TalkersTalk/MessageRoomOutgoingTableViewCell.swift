//
//  MessageRoomOutgoingTableViewCell.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/22/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class MessageRoomOutgoingTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: PaddingUILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMessageLabel(message: String, date: Date?) {
        self.messageLabel.text = message
        self.messageLabel.sizeToFit()
        
        if let date = date {
            //Setting date to local date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            let dateString = dateFormatter.string(from: date)
            self.timeLabel.text = dateString
            self.timeLabel.isHidden = false
            
        } else {
            self.timeLabel.isHidden = true
        }
    }
    
}
