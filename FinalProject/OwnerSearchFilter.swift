//
//  OwnerSearchFilter.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-23.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    class func itemsWithinRadius(postArray: [FoodItem]) -> [FoodItem] {
        let user = User.sharedInstance
        var userLocation: CLLocation?
        var latDouble: Double
        var longDouble: Double
        
        if user.isSearchByAddress! {
            if let latString = user.homeLatitude {
                latDouble = Double(latString)!
            }
            if let longString = user.homeLongitude {
                longDouble = Double(longString)!
            }
 
            
//            if let lat = user.homeLatitude, let doubleLat = Double(lat) {
//                latitude = doubleLat
//            }
//            if let long = user.homeLongitude, let doubleLong = Double(long) {
//                longitude = doubleLong
//            }
//            if latitude != nil && longitude != nil {
//                userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
//            }
        } //else users current location
        
        var array: [FoodItem] = []
        for item in postArray {
            let itemLat = Double(item.latitude!)
            let itemLong = Double(item.longitude!)
            let itemLocation = CLLocation(latitude: itemLat!, longitude: itemLong!)
            let distance = userLocation?.distance(from: itemLocation)
            let distanceKm = distance! / 1000
            if distanceKm <= Double(user.searchRadius!) {
                array.append(item)
            }
        }
        return array
    }
    
}
