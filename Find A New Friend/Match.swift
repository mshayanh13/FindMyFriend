//
//  Match.swift
//  Find A New Friend
//
//  Created by Mohammad Hemani on 3/14/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class Match {
    
    private var _userId: String
    private var _profileImage: UIImage!
    private var _message: String!
    
    init(userId: String, profileImage: UIImage, message: String) {
        
        _userId = userId
        _profileImage = profileImage
        _message = message
        
    }
    
    var userId: String {
        
        return _userId
        
    }
    
    var profileImage: UIImage {
        
        return _profileImage
        
    }
    
    var message: String {
        
        return _message
        
    }
}
