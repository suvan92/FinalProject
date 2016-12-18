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
            self.uid = snapshot.value(forKey: "uid") as? String
            self.email = snapshot.value(forKey: "email") as? String
            self.postedItems = snapshot.value(forKey: "postedItems") as? [String]
            self.requestedItems = snapshot.value(forKey: "requestedItems") as? [String]
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
        let currentUserRef = ref.child(self.uid!)
        currentUserRef.setValue(self.toDictionary())
    }
}
