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
                    self.userlatitude = String(describing: placeMark.location?.coordinate.latitude)
                    self.userlongitude = String(describing: placeMark.location?.coordinate.longitude)
                    //print("latitude: \(self.userlatitude) and longitude \(self.userlongitude)")
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
    
    
}
