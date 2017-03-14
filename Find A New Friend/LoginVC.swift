//
//  LoginVC.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/8/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {

    var signupMode = true
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOrLoginButton: UIButton!
    @IBOutlet weak var changeModeButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeErrorLabelText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        removeErrorLabelText()
        
        if PFUser.current() != nil {
            
            
            /*if PFUser.current()?["isFemale"] != nil && PFUser.current()?["wantsFemaleFriend"] != nil && PFUser.current()?["photo"] != nil {
                
                performSegue(withIdentifier: "FindNewFriendVC", sender: self)
                
            } else { */
            
                performSegue(withIdentifier: "MainVC", sender: self)
            
            //}
        }
        
    }
    
    func removeErrorLabelText() {
        
        errorLabel.text = ""
    }

    @IBAction func signUpOrLogInButtonTapped(_ sender: UIButton) {
        
        if usernameTextField.text != nil || usernameTextField.text != "" || passwordTextField.text != nil || passwordTextField.text != "" {
            
            if signupMode {
                
                let user = PFUser()
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                let acl = PFACL()
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if error != nil {
                        
                        var errorMessage = "Signup failed - please try again"
                        if let error = error as? NSError, let parseError = error.userInfo["error"] as? String {
                            
                            errorMessage = parseError
                            
                        }
                        
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        
                        self.removeErrorLabelText()
                        print("Signed up")
                        
                        self.performSegue(withIdentifier: "MainVC", sender: self)
                        
                    }
                    
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if error != nil {
                        
                        var errorMessage = "Login failed - please try again"
                        if let error = error as? NSError, let parseError = error.userInfo["error"] as? String {
                            
                            errorMessage = parseError
                            
                        }
                        
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        
                        self.removeErrorLabelText()
                        print("Logged In")
                        
                        self.performSegue(withIdentifier: "MainVC", sender: self)
                        
                    }
                    
                })
                
            }
        }
        
    }

    @IBAction func changeModeButtonTapped(_ sender: UIButton) {
        
        removeErrorLabelText()
        
        if signupMode {
            
            signUpOrLoginButton.setTitle("Log In", for: .normal)
            changeModeButton.setTitle("Sign Up", for: .normal)
            signupMode = false
            
        } else {
            
            signUpOrLoginButton.setTitle("Sign Up", for: .normal)
            changeModeButton.setTitle("Log In", for: .normal)
            signupMode = true
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainVC" {
            
            if let mainVC = sender as? MainVC {
                
                mainVC.skipThisView = true
                
            }
            
        }
    }
}

