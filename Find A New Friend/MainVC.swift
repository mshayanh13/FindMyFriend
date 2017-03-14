//
//  MainVC.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/11/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import Parse

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var friendGenderSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    var imagePicker:  UIImagePickerController!
    
    var skipThisView = true
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil{
            removeErrorLabelText()
            
            if skipThisView && PFUser.current()?["isFemale"] != nil && PFUser.current()?["wantsFemaleFriend"] != nil && PFUser.current()?["photo"] != nil {
                
                skipThisView = false
                performSegue(withIdentifier: "FindNewFriendVCFromMain", sender: self)
                
                
            } else {
                
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                
                if let isFemale = PFUser.current()?["isFemale"] as? Bool {
                    
                    genderSwitch.setOn(isFemale, animated: false)
                    
                }
                
                if let wantsFemaleFriend = PFUser.current()?["wantsFemaleFriend"] as? Bool {
                    
                    friendGenderSwitch.setOn(wantsFemaleFriend, animated: false)
                    
                }
                
                if let photo = PFUser.current()?["photo"] as? PFFile {
                    
                    photo.getDataInBackground(block: { (data, error) in
                        
                        if let imageData = data {
                            
                            if let downloadedImage = UIImage(data: imageData) {
                                
                                self.profileImage.image = downloadedImage
                                
                            }
                            
                        }
                        
                    })
                    
                }
                
                /* let urlArray = ["https://az616578.vo.msecnd.net/files/responsive/embedded/any/desktop/2016/07/29/636053558855916017507627482_3%20johnny%20bravo.png", "http://static4.worldofwonder.net/wp-content/uploads/2014/07/Prince-Eric-disney-prince-29841089-1916-1076.jpg", "http://www.cartoondistrict.com/wp-content/uploads/2015/01/Top-25-Hot-Male-Cartoon-Characters-1.jpeg", "http://media.tumblr.com/tumblr_m642hk5Qpu1r6294v.jpg", "http://2.bp.blogspot.com/-wpvQhrx4NLo/Ug4P8QkWKdI/AAAAAAAABnk/ItCTcFJkDBY/s1600/final.png", "https://img.buzzfeed.com/buzzfeed-static/static/2015-04/8/12/enhanced/webdr11/grid-cell-19032-1428508805-1.jpg", "https://s-media-cache-ak0.pinimg.com/736x/a4/a2/d4/a4a2d4ba381379c38e84dac8cbac98b6.jpg"]
                 
                 var counter = 0
                 
                 for urlString in urlArray {
                 
                 counter += 1
                 
                 let url = URL(string: urlString)!
                 
                 do {
                 
                 let data = try Data(contentsOf: url)
                 
                 let imageFile = PFFile(name: "photo.png", data: data)
                 
                 let user = PFUser()
                 
                 user["photo"] = imageFile
                 
                 user.username = String(counter)
                 
                 user.password = "password"
                 
                 user["isFemale"] = false
                 
                 user["wantsFemaleFriend"] = false
                 
                 let acl = PFACL()
                 acl.getPublicWriteAccess = true
                 user.acl = acl
                 
                 user.signUpInBackground(block: { (success, error) in
                 
                 if success {
                 
                 print("user signed up")
                 
                 } else {
                 
                 print(error.debugDescription)
                 
                 }
                 
                 })
                 
                 } catch {
                 
                 print("Could not get data")
                 
                 }
                 
                 }*/
            }
        } else if PFUser.current() == nil {
            
            dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if PFUser.current() != nil && skipThisView {
            removeErrorLabelText()
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["wantsFemaleFriend"] != nil && PFUser.current()?["photo"] != nil {
                
                skipThisView = true
                performSegue(withIdentifier: "FindNewFriendVCFromMain", sender: self)
                
                
            }
            
        }/* else {
            dismiss(animated: true, completion: nil)
        }*/*/
        
        
        
    }
    
    @IBAction func updateProfileImageButtonTapped(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        
        PFUser.current()?["wantsFemaleFriend"] = friendGenderSwitch.isOn
        
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 1.0)
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Update failed - please try again"
                if let error = error as? NSError, let parseError = error.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                self.removeErrorLabelText()
                print("Updated")
                self.performSegue(withIdentifier: "FindNewFriendVCFromMain", sender: self)
                
            }
            
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let imageChosen = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.profileImage.image = imageChosen
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func removeErrorLabelText() {
        
        errorLabel.text = ""
    }
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
        
    }

}
