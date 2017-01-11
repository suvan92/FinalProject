//
//  LocationManager.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    var userlatitude: String? = nil
    var userlongitude: String? = nil
    
    func placemarkFromString(address: String?, completion: @escaping (Error?) -> Swift.Void) {
        if let addressText = address {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressText, completionHandler: { (placeMarkers, error) -> Void in
                if let placeMark = placeMarkers?.last {
                    if let lat = placeMark.location?.coordinate.latitude {
                        self.userlatitude = String(lat)
                    }
                    if let long = placeMark.location?.coordinate.longitude {
                        self.userlongitude = String(long)
                    }
                }
                completion(error)
            })
        }
    }
    
    func returnLatitudeString() -> String {
        if let lat = self.userlatitude {
            return lat
        } else {
            return "error"
        }
    }
    
    func returnLongitudeString() -> String {
        if let long = self.userlongitude {
            return long
        } else {
            return "error"
        }
    }
    
    
//    class func itemsWithinRadius(postArray: [FoodItem]) -> [ItemWithDistance] {
//        let user = User.sharedInstance
//        var latDouble: Double = 0
//        var longDouble: Double = 0
//        var userLocation: CLLocation?
//
//        if user.isSearchByAddress! {
//            if let latString = user.homeLatitude {
//                latDouble = Double(latString)!
//            }
//            if let longString = user.homeLongitude {
//                longDouble = Double(longString)!
//            }
//            userLocation = CLLocation(latitude: latDouble, longitude: longDouble)
//        } //else users current location
//
//        var array: [ItemWithDistance] = []
//        for item in postArray {
//            let itemLat = Double(item.latitude!)
//            let itemLong = Double(item.longitude!)
//            let itemLocation = CLLocation(latitude: itemLat!, longitude: itemLong!)
//            let distance = userLocation?.distance(from: itemLocation)
//            let distanceKm = distance! / 1000
//            if distanceKm <= Double(user.searchRadius!) {
//                let element = ItemWithDistance(foodItem: item, distance: distanceKm)
//                array.append(element)
//            }
//        }
//        return array
  //  }

    
    
}
