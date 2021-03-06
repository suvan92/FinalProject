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

let foodRef = FIRDatabase.database().reference(withPath: "foodItems")

class FoodItem: NSObject {
    
    var name : String
    var dataBaseRef : String
    var ownerID : String
    var photoID : String
    var itemDescription : String
    var itemTags : [String]?
    var requesters : [String]?
    var requesterChosen : Bool
    var acceptedRequester : String?
    var channel: String
    var postDate: Date
    var latitude: String?
    var longitude: String?
    
    
    // MARK: Class Methods
    
    class func saveToDatabase(item :FoodItem, completion: @escaping (_ itemID: String) -> Swift.Void) {
        let newItemRef = foodRef.childByAutoId()
        let referenceString = newItemRef.description()
        item.dataBaseRef = String(referenceString.characters.suffix(20))
        newItemRef.setValue(item.toDictionary()) { error, ref in
            completion(referenceString)
        }
    }
    
    // MARK: Instance Methods
    
    init(name: String, owner: String, photo: String, description: String, tags: [String], latitude: String, longitude: String) {
        self.name = name
        self.ownerID = owner
        self.photoID = photo
        self.itemDescription = description
        self.itemTags = tags
        self.requesters = []
        self.requesterChosen = false
        self.acceptedRequester = nil
        self.dataBaseRef = ""
        self.postDate = Date()
        self.channel = ""
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toDictionary() -> [String:Any?] {
        var result : [String:Any?] = ["name":name,
                                     "ownerID":ownerID,
                                     "photoID":photoID,
                                     "description":itemDescription,
                                     "tags":itemTags,
                                     "requesters":requesters,
                                     "requesterChosen":requesterChosen,
                                     "acceptedRequester":acceptedRequester,
                                     "postDate":postDate.description,
                                     "dataBaseRef":dataBaseRef,
                                     "channel": channel
        ]
        result["longitude"] = longitude
        result["latitude"] = latitude
        return result
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any?]
        
        name = snapshotValue["name"] as! String
        ownerID = snapshotValue["ownerID"] as! String
        photoID = snapshotValue["photoID"] as! String
        itemDescription = snapshotValue["description"] as! String
        itemTags = snapshotValue["tags"] as? [String]
        requesters = snapshotValue["requesters"] as? [String]
        requesterChosen = snapshotValue["requesterChosen"] as! Bool
        acceptedRequester = snapshotValue["acceptedRequester"] as? String
        channel = snapshotValue["channel"] as! String
        postDate = (snapshotValue["postDate"] as! String).dateFromString()
        dataBaseRef = snapshotValue["dataBaseRef"] as! String
        latitude = snapshotValue["latitude"] as? String
        longitude = snapshotValue["longitude"] as? String
    }
    
    func addChannel(withID id: String, completion: @escaping () -> Swift.Void) {
        self.channel = id
        let ref = foodRef.child(dataBaseRef)
        ref.updateChildValues(["channel": self.channel]) { error, ref in
            completion()
        }
    }
}
