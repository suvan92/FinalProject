//
//  NewRequestManager.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class NewRequestManager: NSObject {
    
    class func makeRequest(for foodItem: FoodItem, completion: @escaping (Error?,Bool?) -> Swift.Void) {
        var canMakeRequest = false
        let user = User.sharedInstance
        if var requestArray = foodItem.requesters {
            if requestArray.contains(user.uid!) {
                completion(nil,false)
            } else {
                canMakeRequest = true
                user.addNewRequest(for: foodItem)
                requestArray.append(user.uid!)
            }
        } else {
            canMakeRequest = true
            user.addNewRequest(for: foodItem)
            foodItem.requesters = [user.uid!]
        }
        
        if canMakeRequest {
            let currentUserRef = userRef.child(user.uid!)
            currentUserRef.updateChildValues(["requestedItems":user.requestedItems!]){ error, ref in
                if error == nil {
                    let itemRef = ref.child(foodItem.dataBaseRef)
                    itemRef.updateChildValues(["requesters":foodItem.requesters!]) {error,ref in
                        completion(error,nil)
                    }
                } else {
                    completion(error,nil)
                }
            }
        }
    }

}
