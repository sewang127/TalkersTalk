//
//  MessageRoomNotificationTableViewCell.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/25/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class MessageRoomNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.notificationLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNotificationLabel(label: String) {
        self.notificationLabel.text = label
    }
    
}
