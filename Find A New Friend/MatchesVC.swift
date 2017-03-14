//
//  MatchesVC.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/14/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import Parse

class MatchesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var matchesTableView: UITableView!
    
    var images: [UIImage]!
    var userIds: [String]!
    var messages: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = [UIImage]()
        userIds = [String]()
        messages = [String]()
        
        matchesTableView.delegate = self
        matchesTableView.dataSource = self
        
        let query = PFUser.query()
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if let imageFile = user["photo"] as? PFFile {
                            
                            imageFile.getDataInBackground(block: { (data, error) in
                                
                                if let imageData = data {
                                    
                                    
                                    
                                    let messageQuery = PFQuery(className: "Message")
                                    messageQuery.whereKey("recipient", equalTo: (PFUser.current()?.objectId!)!)
                                    messageQuery.whereKey("sender", equalTo: user.objectId!)
                                    messageQuery.findObjectsInBackground(block: { (objects, error) in
                                        
                                        var messageText = "No message from this user"
                                        
                                        if let objects = objects {
                                            
                                            for message in objects {
                                                
                                                
                                                    
                                                    if let messageContent = message["content"] as? String {
                                                        
                                                       messageText = messageContent
                                                        
                                                    }
                                                    
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        self.images.append(UIImage(data: imageData)!)
                                        self.userIds.append(user.objectId!)
                                        self.messages.append(messageText)
                                        self.matchesTableView.reloadData()
                                        
                                    })
                                    
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
    }

    @IBAction func backTapped(sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = matchesTableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchCell {
        
            let match = Match(userId: userIds[indexPath.row], profileImage: images[indexPath.row], message: messages[indexPath.row])
            cell.configureCell(match: match)
            
            //cell.userIdLabel.text = match.userId
            //cell.matchImage.image = match.profileImage
            //cell.messageLabel.text = match.message
            
            return cell
            
        } else {
            return MatchCell()
        }
    }

}
