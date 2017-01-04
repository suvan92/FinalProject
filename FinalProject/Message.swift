//
//  Message.swift
//  FinalProject
//
//  Created by Tim Beals on 2017-01-03.
//  Copyright © 2017 suvanr. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Message: NSObject {

    var text: String?
    var senderId: String?
    var senderUsername: String?
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any?]
            self.text = snapshotValue["text"] as? String
            self.senderId = snapshotValue["senderId"] as? String
            self.senderUsername = snapshotValue["senderName"] as? String
    }
}
