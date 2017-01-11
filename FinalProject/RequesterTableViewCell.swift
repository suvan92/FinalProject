//
//  RequesterTableViewCell.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class RequesterTableViewCell: UITableViewCell {

    // MARK: - Properties -
    
    @IBOutlet weak var requesterNameLabel: UILabel!
    @IBOutlet weak var requesterDistanceLabel: NSLayoutConstraint!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var cellRequestUser : RequestUser?
    var foodItem : FoodItem?
    //var user : RequestUser?
    
    // MARK: - General Methods -
    
    func setUpCellWith(requestUser: RequestUser, and foodItem: FoodItem) {
        cellRequestUser = requestUser
        //user = requestUser
        requesterNameLabel.text = requestUser.username
        self.foodItem = foodItem
        
        let uid = requestUser.uid
        ImageDownloader.getProfileImage(userId: uid, completion: { image in
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
            self.profileImage.image = image
            self.profileImage.contentMode = .scaleToFill
            //    self.activityIndicator.stopAnimating()
            //    self.activityIndicator.isHidden = true
        })
    }
    
    // MARK: - Actions -
    
    @IBAction func acceptButtonTouched(_ sender: UIButton) {
        AcceptanceManager.accept(requestUser: cellRequestUser!, and: foodItem!) {
            //create channel through notification
            self.notifyAcceptance()
        }
    }
    
    func notifyAcceptance() {
        let requester: [AnyHashable: Any] = ["requester": cellRequestUser!]
        let nCentre = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: "requesterChosen"), object: self, userInfo: requester)
        nCentre.post(notification)
    }

}
