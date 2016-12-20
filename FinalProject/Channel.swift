//
//  Channel.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//
import UIKit
import Firebase

let channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")

class Channel: NSObject {

    var id: String?
    
    func savetoDatabase(completion: @escaping () -> Swift.Void) {
        let newChannelRef = channelRef.childByAutoId()
        let referenceString = newChannelRef.description()
        let id = String(referenceString.characters.suffix(20))
        self.id = id
        newChannelRef.setValue(self.toDictionary()) { error, ref in
            completion()
        }
    }

    func toDictionary() -> [String: Any?] {
        let result = [
            "id": id
        ]
        
        return result
    }
    
    var databaseRef : FIRDatabaseReference? {
        if let channelId = self.id {
           return channelRef.child(channelId) as FIRDatabaseReference
        } else {
            return nil
        }
    }
    
    
}


