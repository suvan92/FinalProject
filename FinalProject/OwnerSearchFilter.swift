//
//  OwnerSearchFilter.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-23.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class OwnerSearchFilter: NSObject {
    
    class func removePostersItems(postArray: [FoodItem]) -> [FoodItem] {
        let currentUser = User.sharedInstance
        var result : [FoodItem] = []
        for item in postArray {
            if item.ownerID != currentUser.uid! {
                result.append(item)
            }
        }
        return result
    }
    
}
