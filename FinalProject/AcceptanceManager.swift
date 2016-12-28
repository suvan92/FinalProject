//
//  AcceptanceManager.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class AcceptanceManager: NSObject {
    
    class func accept(requestUser: RequestUser, and foodItem: FoodItem, completion: @escaping () -> Swift.Void) {
        // get reference to foodItem in database
        let acceptedFoodItemRef = foodRef.child(foodItem.dataBaseRef)
        // update local object and push to database
        foodItem.acceptedRequester = requestUser.uid
        foodItem.requesterChosen = true
        acceptedFoodItemRef.setValue(foodItem.toDictionary()) { error, ref in
            completion()
        }
    }

}
