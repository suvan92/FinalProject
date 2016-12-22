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
    
    var user : RequestUser?
    
    // MARK: - General Methods -
    
    func setUpCellWith(requestUser: RequestUser) {
        user = requestUser
        requesterNameLabel.text = requestUser.email
        acceptButton.layer.borderColor = UIColor.blue.cgColor
        acceptButton.layer.borderWidth = 2
    }
    
    // MARK: - Actions -
    
    @IBAction func acceptButtonTouched(_ sender: UIButton) {
    }

}
