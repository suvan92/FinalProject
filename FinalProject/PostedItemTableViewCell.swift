//
//  PostedItemTableViewCell.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class PostedItemTableViewCell: UITableViewCell {
    
//    let storageRef = FIRStorage.storage().reference(forURL: "gs://finalproject-1b778.appspot.com")
//    let imagesRef = self.storageRef.child("images")
    
    // MARK: Properties
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Cell set up -
    func setUpCell(withItem foodItem: FoodItem) {
        activityIndicator.startAnimating()
        itemTitleLabel.text = foodItem.name
        imageView?.image = getFoodItemImage(foodItem: foodItem) {
            self.activityIndicator.stopAnimating()
        }
        postDateLabel.text = timeAgoSince(foodItem.postDate as Date)
    }
    
    func getFoodItemImage(foodItem: FoodItem, completion: @escaping ()->Swift.Void) -> UIImage {
        var result = UIImage()
        let imagesRef = storageRef.child("images/\(foodItem.dataBaseRef!).jpg")
        imagesRef.data(withMaxSize: 1*1024*1024) { data, error in
            if let error = error {
                // handle error
            } else {
                result = UIImage(data: data!)!
                completion()
            }
        }
        return result
    }
}
