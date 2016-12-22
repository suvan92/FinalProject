//
//  TagManager.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-21.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let tagsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("tags")

class TagManager: NSObject {
    
    func saveToDatabase(foodItem: FoodItem, completion: @escaping () -> Swift.Void)
    {
        if let tagsArray = foodItem.itemTags {
            for tag in tagsArray {
                let newTagRef = tagsRef.child(tag.lowercased())
                newTagRef.observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.value is NSNull {
                        newTagRef.setValue([foodItem.dataBaseRef])
                    } else {
                        var results = snapshot.value as! [String]
                        results.append(foodItem.dataBaseRef)
                        newTagRef.setValue(results) { error, ref in
                            completion()
                        }
                    }
                })
            }
        }
    }
    
    
    
    

}
