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
    var channels : [String]?
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
                                     "requesterChosen":requesterChosen,
                                     "acceptedRequester":acceptedRequester,
                                     "postDate":DateFormatter().string(from: postDate as Date)]
        return result
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        print(snapshot.value)
        let snapshotValue = snapshot.value as! [String:Any?]
        
        name = snapshotValue["name"] as! String
        ownerID = snapshotValue["ownerId"] as? String
        photoID = snapshotValue["photoID"] as! String
        itemDescription = snapshotValue["description"] as! String
        itemTags = snapshotValue["tags"] as! [String]
        requesters = snapshotValue["requesters"] as! [String]
        requesterChosen = snapshotValue["requesterChosen"] as! Bool
        acceptedRequester = snapshotValue["acceptedRequester"] as? String
        channels = snapshotValue["channels"] as? [String]
        postDate = snapshotValue["postDate"] as! NSDate
    }

}
