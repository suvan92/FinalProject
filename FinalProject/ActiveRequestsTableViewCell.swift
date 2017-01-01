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
    @IBOutlet weak var checkIcon: UIImageView!
    
    @IBOutlet weak var postDateLabel: UILabel!
    // MARK: - Cell set up -
    func setUpCell(withItem foodItem: FoodItem) {
        checkIcon.isHidden = true
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
            let channelId = foodItem.channel
            getChannel(with: channelId, completion: { (channel) in
                if channel.requesterId == User.sharedInstance.uid {
                    self.checkIcon.isHidden = false
                    self.acceptanceLabel.text = "Tap to message"
                } else {
                    self.acceptanceLabel.text = "Request pending"
                }
            })
        } else {
            acceptanceLabel.text = "Request pending"
        }
    }
    
//    func setUpAcceptanceLabel(_ isAccepted: Bool) {
//        if isAccepted {
//            acceptanceLabel.text = "Status: Accepted!"
//            acceptanceLabel.textColor = UIColor.green
//        } else {
//            acceptanceLabel.text = "Status: Pending"
//            acceptanceLabel.textColor = UIColor.red
//        }
//    }
    
    //MARK: setupChannel
    func getChannel(with id: String, completion: @escaping(Channel) -> Swift.Void) {
        chanRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel)
        })
    }
}
