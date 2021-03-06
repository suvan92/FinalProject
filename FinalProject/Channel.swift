//
//  Channel.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//
import UIKit
import Firebase

let chanRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")

class Channel: NSObject {

    var id: String?
    var ownerId: String
    var ownerUsername: String
    var requesterId: String
    var requesterUsername: String
    var foodItemName: String
    var isNewMsg: Bool = false
    
    func savetoDatabase(completion: @escaping () -> Swift.Void) {
        let newChannelRef = chanRef.childByAutoId()
        let referenceString = newChannelRef.description()
        let id = String(referenceString.characters.suffix(20))
        self.id = id
        newChannelRef.setValue(self.toDictionary()) { error, ref in
            completion()
        }
    }

    func toDictionary() -> [String: Any?] {
        let result: [String: Any?] = [
            "id": id,
            "ownerId": ownerId,
            "ownerUsername": ownerUsername,
            "requesterId": requesterId,
            "requesterUsername": requesterUsername,
            "foodItemName": foodItemName,
            "isNewMsg": isNewMsg
        ]
        return result
    }
    
    var databaseRef : FIRDatabaseReference? {
        if let channelId = self.id {
           return chanRef.child(channelId) as FIRDatabaseReference
        } else {
            return nil
        }
    }
    
    init(with requester: RequestUser, foodItemName: String) {
        self.id = ""
        let user = User.sharedInstance
        self.ownerId = user.uid!
        self.ownerUsername = user.username!
        self.requesterId = requester.uid
        self.requesterUsername = requester.username
        self.foodItemName = foodItemName
        self.isNewMsg = false
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any?]
        
        self.id = snapshotValue["id"] as! String
        self.ownerId = snapshotValue["ownerId"] as! String
        self.ownerUsername = snapshotValue["ownerUsername"] as! String
        self.requesterId = snapshotValue["requesterId"] as! String
        self.requesterUsername = snapshotValue["requesterUsername"] as! String
        self.foodItemName = snapshotValue["foodItemName"] as! String
        self.isNewMsg = snapshotValue["isNewMsg"] as! Bool
    }
    
    func updateNewMessage(completion: @escaping (Error?) -> Swift.Void) {
        self.databaseRef?.updateChildValues(["isNewMsg": self.isNewMsg], withCompletionBlock: { error, ref in
            completion(error)
        })
    }
}


