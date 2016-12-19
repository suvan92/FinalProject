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
        
        userRef.queryOrdered(byChild: self.uid!).observe(.value, with: { snapshot in
            
            for item in snapshot.children {
                let snapshotValue = (item as! FIRDataSnapshot).value as! [String:Any?]
                print(snapshotValue)
                self.postedItems = snapshotValue["postedItems"] as? [String]
                self.requestedItems = snapshotValue["requestedItems"] as? [String]
            }
            
        })
        
    }
    
//    func setupUserProperties() {
//        
//        userRef.que
//        
//        userRef.queryEqual(toValue: self.uid!).observe(.value, with: { snapshot in
//            
//            print(snapshot)
//            print(self.uid!)
//            
//            let snashotValue = snapshot.value as! [String:Any?]
//            
//            self.uid = snashotValue["uid"] as? String
//            self.email = snashotValue["email"] as? String
//            self.postedItems = snashotValue["postedItems"] as? [String]
//            self.requestedItems = snashotValue["requestedItems"] as? [String]
//            
//        })
//        
//    }
    
    func toDictionary() -> [String: Any?]{
        let result : [String: Any?] = [
            "uid": uid,
            "email": email,
            "postedItems": postedItems,
            "requestedItems": requestedItems
        ]
        return result
    }
    
    func saveToDatabase(email: String, password: String) {
        let currentUserRef = userRef.child(self.uid!)
        currentUserRef.setValue(self.toDictionary()) { error, ref in
            FIRAuth.auth()!.signIn(withEmail: email, password: password) { user, error in
                self.setupUserProperties()
            }
        }
    }
}
