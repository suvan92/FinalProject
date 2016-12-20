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
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        itemTitleLabel.text = foodItem.name
        getFoodItemImage(foodItem: foodItem) { image in
            self.itemImageView.image = image
            self.itemImageView.contentMode = .scaleAspectFit
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        postDateLabel.text = "Posted " + timeAgoSince(foodItem.postDate)
    }
    
    func getFoodItemImage(foodItem: FoodItem, completion: @escaping (_ image: UIImage)->Swift.Void) {
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
}
