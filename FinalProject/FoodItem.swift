//
//  FoodItem.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class FoodItem: NSObject {
    
    let ref : FIRDatabaseReference?
    let name : String
    let owner : User
    let photoURL : String?
    let itemDescription : String
    let category : String
    var requesters : [User]
    var requesterChosen : Bool
    var acceptedRequester : User?
    
    init(name: String, owner: User, photo: String, description: String, category: String) {
        self.name = name
        self.owner = owner
        self.photoURL = photo
        self.itemDescription = description
        self.category = category
        self.requesters = []
        self.requesterChosen = false
        self.acceptedRequester = nil
        self.ref = nil
    }
    
    func toDictionary() {
        
    }

}
