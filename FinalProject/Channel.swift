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
private var channelRefHandle: FIRDatabaseHandle?

class Channel: NSObject {

    var id: String?
    
    func savetoDatabase() {
        let newChannelRef = channelRef.childByAutoId()
        let referenceString = newChannelRef.description()
        let id = String(referenceString.characters.suffix(20))
        self.id = id
        newChannelRef.setValue(self.toDictionary())
    }

    func toDictionary() -> [String: Any?] {
        let result = [
            "id": id
        ]
        
        return result
    }
    
    
}


