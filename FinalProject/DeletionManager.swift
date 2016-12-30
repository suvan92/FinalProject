//
//  DeletionManager.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-27.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class DeletionManager: NSObject {
    
    class func delete(foodItem: FoodItem, completion: @escaping () -> Swift.Void) {
        
        // delete requesters' references
        
        if let requesters = foodItem.requesters {
            var currentCall = 0
            let totalCalls = requesters.count
            
            for reqUser in requesters {
                DeletionManager.getRequestedItems(forUser: reqUser, and: foodItem) { requestsArray in
                    userRef.child(reqUser).updateChildValues(["requestedItems":requestsArray]) { error, ref in
                        currentCall += 1
                        if currentCall == totalCalls {
                            // delete owner's ref to foodItem
                            DeletionManager.deleteOwnerRef(for: foodItem) {
                                // delete item itself
                                DeletionManager.deleteItem(foodItem) {completion()}
                            }
                        }
                    }
                }
            }
        } else { // if there are no requesters go straight to removing owner ref and deleting item
            DeletionManager.deleteOwnerRef(for: foodItem) {
                DeletionManager.deleteItem(foodItem) {completion()}
            }
        }
    }
    
    class private func getRequestedItems(forUser userId: String, and foodItem: FoodItem, completion: @escaping ([String]) -> Swift.Void) {
        
        userRef.child(userId).observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! [String:Any?]
            
            let requestsArray = snapshotValue["requestedItems"] as! [String]
            let updatedArray = requestsArray.filter{$0 != foodItem.dataBaseRef}
            completion(updatedArray)
        })
    }
    
    class private func deleteOwnerRef(for foodItem: FoodItem, completion: @escaping () -> Swift.Void) {
        let currentUser = User.sharedInstance
        let updatedArray = currentUser.postedItems!.filter{ $0 != foodItem.dataBaseRef }
        userRef.child(currentUser.uid!).updateChildValues(["postedItems":updatedArray]) { error, ref in
            if error == nil {
                completion()
            } else {
                // handle error
            }
        }
    }
    
    class private func deleteItem(_ foodItem: FoodItem, completion: @escaping () -> Swift.Void) {
        foodRef.child(foodItem.dataBaseRef).removeAllObservers()
        foodRef.child(foodItem.dataBaseRef).removeValue() { error, ref in
            completion()
        }
    }

}
