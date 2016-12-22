//
//  SearchManager.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-21.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class SearchManager: NSObject {
    
    // MARK: - Properties -
    var currentCallNumber : Int
    var totalCallNumber : Int
    var foodItemsToPull : Set<String>
    var instantiatedFoodItems : [FoodItem]
    
    // MARK: - General Methods -
    
    override init()
    {
        currentCallNumber = 0
        totalCallNumber = 0
        foodItemsToPull = Set()
        instantiatedFoodItems = []
        super.init()
    }
    
    func searchForItems(searchArray: [String], completion: @escaping ([FoodItem]) -> Swift.Void)
    {
        totalCallNumber = searchArray.count
        for item in searchArray {
            let tagRef = tagsRef.child(item.lowercased())
            tagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    self.currentCallNumber += 1
//                    if self.currentCallNumber == self.totalCallNumber {
//                        completion(self.foodItemsToPull)
//                    }
                } else {
                    let foodItemRefs = snapshot.value as! [String]
                    for ref in foodItemRefs {
                        DispatchQueue.main.async {
                            self.foodItemsToPull.insert(ref)
                        }
                    }
                    self.currentCallNumber += 1
                    if self.currentCallNumber == self.totalCallNumber {
                        self.getFoodItemObjects(itemRefs: self.foodItemsToPull, completion: { (foodItems) in
                            completion(foodItems)
                        })
                    }
                }
            })
        }
    }
    
    func getFoodItemObjects(itemRefs: Set<String>, completion: @escaping ([FoodItem]) -> Swift.Void) {
        currentCallNumber = 0
        totalCallNumber = itemRefs.count
        for itemRef in itemRefs {
            ref.child(itemRef).observeSingleEvent(of: .value, with: { (snapshot) in
                let foodItem = FoodItem(snapshot: snapshot)
                self.instantiatedFoodItems.append(foodItem)
                self.currentCallNumber += 1
                if self.currentCallNumber == self.totalCallNumber {
                    completion(self.instantiatedFoodItems)
                }
            })
        }
    }
    
//    ref.child(itemReferenceValue).observeSingleEvent(of: .value, with: { snap in
//    let foodItem = FoodItem(snapshot: snap)
//    self.arrayOfPosts?.append(foodItem)
//    self.tableView.reloadData()
//    })

} // class
