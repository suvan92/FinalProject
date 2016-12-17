//
//  User.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    let uid : String
    let email : String
    var postedItems : [String]
    var requestedItems : [String]
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.postedItems = []
        self.requestedItems = []
    }
    
    // Must get reference to user in database and download postedItems and requestedItems arrays separate from authData init method
//    init(authData: FIRUser) {
//        uid = authData.uid
//        email = authData.email!
//    }
    
    
    

}
