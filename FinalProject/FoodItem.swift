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
    
    let name : String
    let ownerID : String?
    let photoID : String
    let itemDescription : String
    var itemTags : [String]
    var requesters : [String]
    var requesterChosen : Bool
    var acceptedRequester : String?
    
    init(name: String, owner: String?, photo: String, description: String, tags: [String]) {
        self.name = name
        self.ownerID = owner
        self.photoID = photo
        self.itemDescription = description
        self.itemTags = tags
        self.requesters = []
        self.requesterChosen = false
        self.acceptedRequester = nil
    }
    
    func toDictionary() -> [String:Any?] {
        let result : [String:Any?] = ["name":name,
                                     "ownerID":nil,
                                     "photoID":photoID,
                                     "description":itemDescription,
                                     "tags":itemTags,
                                     "requesters":requesters,
                                     "requesterChosen":false,
                                     "acceptedRequester":nil]
        return result
    }

}
