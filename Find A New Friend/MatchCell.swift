//
//  MatchCell.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/14/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import Parse

class MatchCell: UITableViewCell {

    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBAction func sendTapped(sender: UIButton) {
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = userIdLabel.text
        message["content"] = messageTextField.text
        
        message.saveInBackground { (success, error) in
            
            if success {
                
                self.messageTextField.text = ""
                
            }
            
        }
        
    }
    
    func configureCell(match: Match) {
        
        matchImage.image = match.profileImage
        messageLabel.text = match.message
        userIdLabel.text = match.userId
        
    }

}
