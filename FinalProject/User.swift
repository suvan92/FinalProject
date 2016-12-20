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
    var channels: [String]?
    
    static let sharedInstance = User()
    private override init() {}
    
    
    func setupUserProperties(completion: @escaping () -> Swift.Void) {
        userRef.child(self.uid!).observe(.value, with: { snapshot in
            
            let snapshotValue = snapshot.value as! [String:Any?]
            print(snapshotValue)
            self.postedItems = snapshotValue["postedItems"] as? [String]
            self.requestedItems = snapshotValue["requestedItems"] as? [String]
            self.channels = snapshotValue["channels"] as? [String]
            completion()
        })
    }
    
    func toDictionary() -> [String: Any?]{
        let result : [String: Any?] = [
            "uid": uid,
            "email": email,
            "postedItems": postedItems,
            "requestedItems": requestedItems,
            "channels": channels
        ]
        return result
    }
    
    func saveToDatabase(completion: @escaping () -> Swift.Void) {
        let currentUserRef = userRef.child(self.uid!)
        currentUserRef.setValue(self.toDictionary()) { error, ref in
            completion()
        }
    }
    
    func addFoodItem(withID itemRef: String, completion: @escaping (Error?) -> Swift.Void) {
        let truncatedItemRef = String(itemRef.characters.suffix(20))
        if postedItems != nil {
            self.postedItems?.append(truncatedItemRef)
        } else {
            self.postedItems = [truncatedItemRef]
        }
        let currentUserRef = userRef.child(self.uid!)
        currentUserRef.updateChildValues(["postedItems":self.postedItems!]) { error, ref in
            completion(error)
        }
    }
    
    func addChannel(withID itemRef: String, completion: @escaping () -> Swift.Void) {
        if channels != nil {
            self.channels?.append(itemRef)
        } else {
            self.channels = [itemRef]
        }
        let currentUserRef = userRef.child(self.uid!)
        currentUserRef.updateChildValues(["channels":self.channels!]) { error, ref in
            completion()
        }
    }
}
