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
    var username: String?
    var isSearchByAddress: Bool?
    var addressStreet: String?
    var addressCity: String?
    var addressPostCode: String?
    var addressProvince: String?
    var addressCountry: String?
    var searchRadius: Int?
    var homeLatitude: String?
    var homeLongitude: String?
    
    static let sharedInstance = User()
    private override init() {}
    
    
    func setupUserProperties(completion: @escaping () -> Swift.Void) {
        userRef.child(self.uid!).observe(.value, with: { snapshot in
            let snapshotValue = snapshot.value as! [String: Any?]
            self.postedItems = snapshotValue["postedItems"] as? [String]
            self.requestedItems = snapshotValue["requestedItems"] as? [String]
            self.channels = snapshotValue["channels"] as? [String]
            self.username = snapshotValue["username"] as? String
            self.isSearchByAddress = snapshotValue["isSearchByAddress"] as? Bool
            self.addressStreet = snapshotValue["addressStreet"] as? String
            self.addressCity = snapshotValue["addressCity"] as? String
            self.addressPostCode = snapshotValue["addressPostCode"] as? String
            self.addressProvince = snapshotValue["addressProvince"] as? String
            self.addressCountry = snapshotValue["addressCountry"] as? String
            self.searchRadius = snapshotValue["searchRadius"] as? Int
            self.homeLatitude = snapshotValue["homeLatitude"] as? String
            self.homeLongitude = snapshotValue["homeLongitude"] as? String
            completion()
        })
    }
    
    func toDictionary() -> [String: Any?]{
        var result : [String:Any?] = [:]
        result["uid"] = uid
        result["email"] = email
        result["postedItems"] = postedItems
        result["requestedItems"] = requestedItems
        result["channels"] = channels
        result["username"] = username
        result["isSearchByAddress"] = isSearchByAddress
        result["addressStreet"] = addressStreet
        result["addressCity"] = addressCity
        result["addressPostCode"] = addressPostCode
        result["addressProvince"] = addressProvince
        result["addressCountry"] = addressCountry
        result["searchRadius"] = searchRadius
        result["homeLatitude"] = homeLatitude
        result["homeLongitude"] = homeLongitude
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
    
    func updateUserSettings(completion: @escaping (Error?) -> Swift.Void) {
        userRef.updateChildValues([self.uid!: self.toDictionary()], withCompletionBlock: { error, ref in
            completion(error)
        })
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
    
    func addNewRequest(for foodItem: FoodItem) {
        if var requestsArray = self.requestedItems {
            requestsArray.append(foodItem.dataBaseRef)
        } else {
            self.requestedItems = [foodItem.dataBaseRef]
        }
    }
}
