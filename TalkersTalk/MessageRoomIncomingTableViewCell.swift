//
//  MessageRoomIncomingTableViewCell.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/16/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class MessageRoomIncomingTableViewCell: UITableViewCell {

    @IBOutlet weak var textMessageLabelLeft: PaddingUILabel!
    @IBOutlet weak var strangerNameLabel: UILabel!
    @IBOutlet weak var timeLabelLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMessageLabel(message: String, name: String, date: Date?) {
        self.textMessageLabelLeft.text = message
        self.strangerNameLabel.text = name
        self.textMessageLabelLeft.sizeToFit()
    
        if let date = date {
            //Setting date to local date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            let dateString = dateFormatter.string(from: date)
            self.timeLabelLeft.text = dateString
            self.timeLabelLeft.isHidden = false
        } else {
            self.timeLabelLeft.isHidden = true
        }
    }
    
}
