//
//  FindNewFriendVC.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/12/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import Parse

class FindNewFriendVC: UIViewController {

    var displayedUserID = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        imageView.isUserInteractionEnabled = false
        imageView.addGestureRecognizer(gesture)
        swipeLabel.text = "Swife left to reject, right to accept"
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if let geopoint = geopoint {
                
                PFUser.current()?["location"] = geopoint
                PFUser.current()?.saveInBackground()
                
                
                
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateImage()
        swipeLabel.text = "Swife left to reject, right to accept"
    }
    
    func updateImage() {
        
        let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["wantsFemaleFriend"])!)
        query?.whereKey("wantsFemaleFriend", equalTo: (PFUser.current()?["isFemale"])!)
        
        let selfObjectId = PFUser.current()?.objectId
        var ignoredUsers = [selfObjectId!]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array//<String>
            
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array//<String>
            
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
                
            }
            
        }
        
        query?.limit = 1
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if let imageFile = user["photo"] as? PFFile {
                            imageFile.getDataInBackground(block: { (data, error) in
                                
                                if let imageData = data {
                                    
                                    self.displayedUserID = user.objectId!
                                    self.imageView.isUserInteractionEnabled = true
                                    self.imageView.image = UIImage(data: imageData)
                                    
                                }
                                
                            })
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            //no users found to accept, reject
            self.imageView.isUserInteractionEnabled = false
            self.imageView.image = UIImage(named: "noun_138926_cc")
            self.swipeLabel.text = "No more people to accept/reject"
            
        })
        
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(40 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" && displayedUserID != "" {
                
                PFUser.current()?.addUniqueObject(displayedUserID, forKey: acceptedOrRejected)
                PFUser.current()?.saveInBackground(block: { (success, errror) in
                    
                    self.updateImage()
                    
                })
                
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
            
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                
                print(error.debugDescription)
                
            }
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func profileTapped(sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FindNewFriendVCFromMain" {
            
            if let mainVC = sender as? MainVC {
                
                mainVC.skipThisView = false
                
            }
            
        }
    }

}
