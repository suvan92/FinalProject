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
        var requestsArrayExists = false
        let user = User.sharedInstance
        
        // create requests array to be updated
        var requestsArray : [String]?
        if let temp = foodItem.requesters {
            requestsArrayExists = true
            requestsArray = temp
        } else {
            requestsArray = []
        }
        
        // update requestsArray
        if (requestsArray?.contains(user.uid!))! {
            completion(nil,false)
        } else {
            canMakeRequest = true
            user.addNewRequest(for: foodItem)
            requestsArray?.append(user.uid!)
        }
        // make appropriate update or set network call to database
        if canMakeRequest {
            let itemRef = foodRef.child(foodItem.dataBaseRef)
            if requestsArrayExists {
                itemRef.updateChildValues(["requesters":requestsArray!]) { error, ref in
                    completion(error,nil)
                }
            } else {
                itemRef.child("requesters").setValue(requestsArray!) { error, ref in
                    completion(error,nil)
                }
            }
        }
    }
}
