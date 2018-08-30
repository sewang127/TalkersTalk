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
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            print("Current device is Phone type")
            self.notificationLabel.font = self.notificationLabel.font.withSize(12.0)
        }
    }
    
    override func prepareForReuse() {
        self.notificationLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNotificationLabel(label: String) {
        //Change the font size accordinf to device type
        self.notificationLabel.text = label
    }
    
}
