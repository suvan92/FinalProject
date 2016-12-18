//
//  User.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let userRef = FIRDatabase.database().reference(withPath: "users")

class User: NSObject {
    
    var uid : String?
    var email : String?
    var postedItems : [String]?
    var requestedItems : [String]?
    
    static let sharedInstance = User()
    private override init() {}
    
    func setupUserProperties() {
        userRef.queryEqual(toValue: self.uid!).observe(.value, with: { snapshot in
            
            let snapshotValue = snapshot.value as! [String:Any?]
            
            self.uid = snapshotValue["uid"] as? String
            self.email = snapshotValue["email"] as? String
            self.postedItems = snapshotValue["postedItems"] as? [String] //do we need this in for loop?
            self.requestedItems = snapshotValue["requestedItems"] as? [String] //do we need this in for loop?
        })
        
        
    }
    
    func toDictionary() -> [String: Any?]{
        let result : [String: Any?] = [
            "uid": uid,
            "email": email,
            "postedItems": postedItems,
            "requestedItems": requestedItems
        ]
        return result
    }
    
    func saveToDatabase() {
        let currentUserRef = userRef.child(self.uid!)
        currentUserRef.setValue(self.toDictionary()) {
            // self.delegate.signUserIn()
        }
        print("stop")
    }
    
    //set user to observe for changes to itself
    func observeForChanges() {
        userRef.child(self.uid!).observe(.value, with: { snapshot in
            let snapshotValue = snapshot.value as! [String: Any?]
            
            self.uid  = snapshotValue["uid"] as! String
            self.email = snapshotValue["email"] as! String
            self.postedItems = snapshotValue["postedItems"] as! [String]
            self.requestedItems = snapshotValue["requestedItems"] as! [String]
        })
    }
    
}
