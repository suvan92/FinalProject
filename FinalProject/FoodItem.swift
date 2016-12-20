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

let ref = FIRDatabase.database().reference(withPath: "foodItems")

class FoodItem: NSObject {
    
    let name : String
    var dataBaseRef : String?
    let ownerID : String?
    let photoID : String
    let itemDescription : String
    var itemTags : [String]
    var requesters : [String]
    var requesterChosen : Bool
    var acceptedRequester : String?
    var postDate : NSDate
    
    // MARK: Class Methods
    
    class func saveToDatabase(item :FoodItem, completion: @escaping (_ itemID: String) -> Swift.Void) {
        let newItemRef = ref.childByAutoId()
        let referenceString = newItemRef.description()
        item.dataBaseRef = String(referenceString.characters.suffix(20))
        newItemRef.setValue(item.toDictionary()) { error, ref in
            completion(referenceString)
        }
    }
    
    
    // MARK: Instance Methods
    
    init(name: String, owner: String?, photo: String, description: String, tags: [String]) {
        self.name = name
        self.ownerID = owner
        self.photoID = photo
        self.itemDescription = description
        self.itemTags = tags
        self.requesters = []
        self.requesterChosen = false
        self.acceptedRequester = nil
        self.dataBaseRef = nil
        self.postDate = NSDate()
    }
    
    func toDictionary() -> [String:Any?] {
        let result : [String:Any?] = ["name":name,
                                     "ownerID":ownerID,
                                     "photoID":photoID,
                                     "description":itemDescription,
                                     "tags":itemTags,
                                     "requesters":requesters,
                                     "requesterChosen":false,
                                     "acceptedRequester":nil]
        return result
    }

}
