//
//  ActiveChatTableViewCell.swift
//  FinalProject
//
//  Created by Tim Beals on 2017-01-01.
//  Copyright © 2017 suvanr. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ActiveChatTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var foodItemLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    var isPostItem: Bool = false
    var cellChannel: Channel?
    
    func setUpCellWith(channel: Channel) {
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
        let userId: String?
        cellChannel = channel
        
        if isPostItem {
            usernameLabel.text = channel.requesterUsername
            userId = channel.requesterId
        } else {
            usernameLabel.text = channel.ownerUsername
            userId = channel.ownerId
        }
        foodItemLabel.text = "re: \(channel.foodItemName)"
        getLastMessage()
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

    func getLastMessage() {
        cellChannel?.databaseRef?.child("messages").observe(.value, with: { (snapshot) in
            
            var messages: [Message] = []
            for item in snapshot.children {
                let message = Message(snapshot: item as! FIRDataSnapshot)
                messages.append(message)
            }
            if let current = messages.last {
                let user = User.sharedInstance
                let text = current.text!
                if current.senderId == user.uid {
                    self.lastMessageLabel.text = "You: \(text)"
                } else {
                    if (self.cellChannel?.isNewMsg)! {
                        self.lastMessageLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
                        self.lastMessageLabel.textColor = UIColor.black
                        self.lastMessageLabel.text = "\(text)"
                    }
                }
            }
        })
    }
}
