//
//  ImageDownloader.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-21.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    class func getFoodItemImage(foodItem: FoodItem, completion: @escaping (_ image: UIImage)->Swift.Void) {
        var result = UIImage()
        let imagesRef = storageRef.child("images")
        let photoRef = imagesRef.child(foodItem.photoID)
        photoRef.data(withMaxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                result = UIImage(data: data!)!
                completion(result)
            }
        }
    }
    
    class func getProfileImage(userId: String, completion: @escaping(_ image: UIImage) -> Swift.Void) {
        var result = UIImage()
        let profileImagesRef = storageRef.child("profileImages")
        let photoRef = profileImagesRef.child(userId)
        photoRef.data(withMaxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                result = UIImage(data: data!)!
                completion(result)
            }
        }
    }
}
