//
//  ActiveChatTableViewCell.swift
//  FinalProject
//
//  Created by Tim Beals on 2017-01-01.
//  Copyright © 2017 suvanr. All rights reserved.
//

import UIKit

class ActiveChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var foodItemLabel: UILabel!

    func setUpCellWith(channel: Channel, isPostItem: Bool) {
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
        let userId: String?
        
        if isPostItem {
            usernameLabel.text = channel.requesterUsername
            userId = channel.requesterId
        } else {
            usernameLabel.text = channel.ownerUsername
            userId = channel.ownerId
        }
        ImageDownloader.getProfileImage(userId: userId!, completion: { image in
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
            self.profilePic.clipsToBounds = true
            self.profilePic.image = image
            self.profilePic.contentMode = .scaleToFill
            //    self.activityIndicator.stopAnimating()
            //    self.activityIndicator.isHidden = true
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    

}
