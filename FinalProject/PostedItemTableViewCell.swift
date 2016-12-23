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
    
    // MARK: Properties
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var numOfRequestsLabel: UILabel!
    
    // MARK: - Cell set up -
    func setUpCell(withItem foodItem: FoodItem) {
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        itemTitleLabel.text = foodItem.name
        ImageDownloader.getFoodItemImage(foodItem: foodItem, completion: {(image) in
            self.itemImageView.image = image
            self.itemImageView.contentMode = .scaleAspectFit
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        })
        postDateLabel.text = "Posted " + timeAgoSince(foodItem.postDate)
        if foodItem.requesterChosen {
            numOfRequestsLabel.text = "Accepted! Tap to enter chat"
            numOfRequestsLabel.textColor = UIColor.green
        } else {
            numOfRequestsLabel.textColor = UIColor.black
            if let requestCount = foodItem.requesters?.count {
                numOfRequestsLabel.text = "Requests: \(requestCount)"
            } else {
                numOfRequestsLabel.text = "Requests: 0"
            }
        }
        
    }
    
}
