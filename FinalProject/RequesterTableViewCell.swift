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
    var cellRequestUser : RequestUser?
    var foodItem : FoodItem?
    
    var user : RequestUser?
    
    // MARK: - General Methods -
    
    func setUpCellWith(requestUser: RequestUser, and foodItem: FoodItem) {
        cellRequestUser = requestUser
        user = requestUser
        requesterNameLabel.text = requestUser.email
        self.foodItem = foodItem
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
