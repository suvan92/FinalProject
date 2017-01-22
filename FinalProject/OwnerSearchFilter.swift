//
//  OwnerSearchFilter.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-23.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import CoreLocation

struct ItemWithDistance {
    var foodItem: FoodItem?
    var distance: Double?
}

class OwnerSearchFilter: NSObject, CLLocationManagerDelegate {
    
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
    
    class func itemsWithinRadius(postArray: [FoodItem], currentLocation: CLLocation) -> [ItemWithDistance] {
        let user = User.sharedInstance
        var latDouble: Double = 0
        var longDouble: Double = 0
        var userLocation: CLLocation?
        
        if user.isSearchByAddress! {
            if let latString = user.homeLatitude {
                latDouble = Double(latString)!
            }
            if let longString = user.homeLongitude {
                longDouble = Double(longString)!
            }
            userLocation = CLLocation(latitude: latDouble, longitude: longDouble)
        } else {
            //else user's current location
            userLocation = currentLocation
        }
        
        var array: [ItemWithDistance] = []
        for item in postArray {
            let itemLat = Double(item.latitude!)
            let itemLong = Double(item.longitude!)
            let itemLocation = CLLocation(latitude: itemLat!, longitude: itemLong!)
            let distance = userLocation?.distance(from: itemLocation)
            let distanceKm = distance! / 1000
            if distanceKm <= Double(user.searchRadius!) {
                let element = ItemWithDistance(foodItem: item, distance: distanceKm)
                array.append(element)
            }
        }
        return array
    }
    
}
