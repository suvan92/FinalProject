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
    var foodItemsToPull : Set<String>
    
    // MARK: - General Methods -
    
    override init()
    {
        foodItemsToPull = Set()
        super.init()
    }
    
    func searchForItems(searchArray: [String], completion: @escaping (String) -> Swift.Void)
    {
        
        for item in searchArray {
            let tagRef = tagsRef.child(item.lowercased())
            tagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    // no items
                } else {
                    let foodItemRefs = snapshot.value as! [String]
                    for ref in foodItemRefs {
                        DispatchQueue.main.async {
                            self.foodItemsToPull.insert(ref)
                            completion(item)
                        }
                    }
                }
            })
        }
    }

} // class
