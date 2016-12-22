//
//  ActiveRequestsTableViewCell.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class ActiveRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var acceptanceLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
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
        setUpAcceptanceLabel(foodItem.requesterChosen)
    }
    
    func setUpAcceptanceLabel(_ isAccepted: Bool) {
        
        if isAccepted {
            acceptanceLabel.text = "Status: Accepted!"
            acceptanceLabel.textColor = UIColor.green
        } else {
            acceptanceLabel.text = "Status: Pending"
            acceptanceLabel.textColor = UIColor.red
        }
        
    }
}
