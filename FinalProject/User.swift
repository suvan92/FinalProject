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
            
            let snashotValue = snapshot.value as! [String:Any?]
            
            self.uid = snashotValue["uid"] as? String
            self.email = snashotValue["email"] as? String
            self.postedItems = snashotValue["postedItems"] as? [String]
            self.requestedItems = snashotValue["requestedItems"] as? [String]
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
}
