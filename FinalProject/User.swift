//
//  User.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let uid : String
    let email : String
    var postedItems : [FoodItem]
    var requestedItems : [FoodItem]
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.postedItems = []
        self.requestedItems = []
    }
    

}
